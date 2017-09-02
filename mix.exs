defmodule PlugPassword.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_password,
      version: "0.2.0",
      elixir: "~> 1.5",
      description: "Plug to simply secure your server with password",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.4.3"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Bart Lecki"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/azranel/plug_password"}
    ]
  end
end
