defmodule ExOkex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_okex,
      version: "0.7.0",
      elixir: "~> 1.20.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      name: "ExOkex",
      description: "OKEx API client for Elixir",
      source_url: "https://github.com/yurikoval/ex_okex"
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 3.0"},
      {:jason, "~> 1.4"},
      {:websockex, "~> 0.5.1"},
      {:mapail, "~> 1.0"},
      {:meck, "~> 1.2", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "ExOkex",
      extras: ["README.md"]
    ]
  end

  defp package do
    [
      name: :ex_okex,
      maintainers: ["Yuri Koval'ov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/yurikoval/ex_okex"}
    ]
  end
end
