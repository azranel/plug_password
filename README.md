# PlugPassword

[![Build Status](https://travis-ci.org/azranel/plug_password.svg?branch=master)](https://travis-ci.org/azranel/plug_password)

Simple authentication plug based on [rack_password](https://github.com/netguru/rack_password).
Similary it will ask you for password only once and store it in your cookie (not like basic auth).

[Hex.pm package](https://hex.pm/packages/plug_password)
[HexDocs](https://hexdocs.pm/plug_password)

## Installation

The package can be installed by adding `plug_password` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_password, "~> 0.3.0"}
  ]
end
```

then plug it before your router:

```elixir
plug PlugPassword.Block, passwords: ["your", "passwords", "here"]

plug PlugPasswordTestWeb.Router
```

check possible options to pass to plug in [HexDocs](https://hexdocs.pm/plug_password/PlugPassword.Block.html).
