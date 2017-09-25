defmodule GameServer do
  def start(_type, _args) do
    Submarine.start_link([])
    {:ok, _} = :cowboy.start_http(
      :http,
      100,
      [{:port, 8080}],
      [{:env, [{:dispatch, build_dispatch_config()}]}]
    )
  end

  def build_dispatch_config do
    :cowboy_router.compile([
      # match all hostnames
      { :_, [
        {"/", :cowboy_static, {:priv_file, :gameserver, "index.html"}},
        {"/websocket", WebsocketHandler, []}
      ]}
    ])
  end
end
