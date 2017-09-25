defmodule GameServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gameserver,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:cowboy, :ranch],
      extra_applications: [:logger],
      mod: {GameServer, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.1"},
      {:namegen, "~> 0.1.2"},
      {:poison, "~> 3.1"},
      {:submarine, "~> 0.0.2" }
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
