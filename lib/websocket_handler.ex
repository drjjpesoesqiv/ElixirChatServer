defmodule WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  def random_id do
    name = Poison.decode!(Namegen.gen)
    "#{name["first"]} #{name["last"]}"
  end

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    main = self
    spawn fn -> 
      Submarine.subscribe(main, random_id(), fn msg ->
        send main, msg
      end)
    end

    {protocol, _} = :cowboy_req.header(<<"sec-websocket-protocol">>, req)
    req = :cowboy_req.set_resp_header(<<"sec-websocket-protocol">>, protocol, req)
    {:ok, req, {}}
  end

  def websocket_handle({:text, msg}, req, state) do
    decoded = Poison.decode!(msg)
    case decoded["action"] do
      "publish"  -> Submarine.publish(self, decoded["msg"])
      "identify" -> Submarine.identify(self, decoded["msg"])
    end

    {:reply, {:text, "{}"}, req, state}
  end

  def websocket_info({id, msg}, req, state) do
    {:reply, {:text, Poison.encode!(%{id: id, msg: msg})}, req, state}
  end

  def websocket_terminate(_info, req, state) do
    IO.puts "terminated"
    Submarine.unsubscribe(self)
    {:ok, req, state}
  end
end