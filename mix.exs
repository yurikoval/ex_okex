defmodule ExOkex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_okex,
      version: "0.6.0",
      elixir: "~> 1.10",
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
      {:httpoison, "~> 1.0"},
      {:jason, "~> 1.1"},
      {:websockex, "~> 0.4.0"},
      {:mapail, "~> 1.0"},
      {:mock, "~> 0.3.3", only: :test},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:exvcr, "~> 0.10", only: :test},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1.0", only: :dev, runtime: false}
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
