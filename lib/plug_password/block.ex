defmodule PlugPassword.Block do
  @moduledoc """
  Plug used to add simple authentication.

  Options should be provided with at least passwords field.
  """
  import Plug.Conn

  def init(options), do: options

  @doc """
  Checks if password is matching.
  """
  def call(conn, options) do
  end
end
