# PlugPassword

Simple authentication plug based on [rack_password](https://github.com/netguru/rack_password).
Similary it will ask you for password only once and store it in your cookie (not like basic auth).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `plug_password` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_password, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/plug_password](https://hexdocs.pm/plug_password).
