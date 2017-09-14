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
plug PlugPassword.Block, passwords: ["hello", world],
  template: Authentication,
  path_whitelist: ~r/users/,
  ip_whitelist: ["86.123.112.78"],
  custom_rule: &Authentication.custom_rule/1

plug PlugPasswordTestWeb.Router
```

check possible options to pass to plug in [HexDocs](https://hexdocs.pm/plug_password/PlugPassword.Block.html).
