defmodule ExParametarized.Mixfile do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :ex_parametarized,
      version: @version,
      elixir: "~> 1.0",
      name: "ExParametarized",
      source_url: "https://github.com/KazuCocoa/ex_parametarized",
      description: "Simple macro for parametarized testing",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      package: package
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.9", only: :dev}
    ]
  end

  defp package do
    [
      files: ~w(lib config mix.exs README.md LICENSE),
      contributors: ["Kazuaki Matsuo"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/KazuCocoa/ex_parametarized"}
    ]
  end
end
