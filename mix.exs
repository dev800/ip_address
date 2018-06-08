defmodule IpAddress.Mixfile do
  use Mix.Project

  def project do
    [app: :ip_address,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  def package do
    [
      maintainers: ["happy"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/dev800/ip_address"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [

    ]
  end
end
