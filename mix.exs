defmodule FFI.Mixfile do
  use Mix.Project

  def project do
    [app: :ffi,
     version: "0.0.1-alpha",
     elixir: "~> 1.2",
     compilers: [:elixir_make] ++ Mix.compilers,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:elixir_make, "~> 0.1.0"}]
  end
end
