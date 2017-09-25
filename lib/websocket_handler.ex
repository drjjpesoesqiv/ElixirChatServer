defmodule WebsocketHandler do
  @behaviour :cowboy_websocket_handler

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    name = Poison.decode!(Namegen.gen)
    main = self
    spawn fn -> 
      Submarine.subscribe(main, "#{name["first"]} #{name["last"]}", fn msg ->
        send main, msg
      end)
    end

    {protocol, _} = :cowboy_req.header(<<"sec-websocket-protocol">>, req)
    req = :cowboy_req.set_resp_header(<<"sec-websocket-protocol">>, protocol, req)
    {:ok, req, {}}
  end

  def websocket_handle({:text, msg}, req, state) do
    Submarine.publish(self, msg)
    {:reply, {:text, "reply"}, req, state}
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