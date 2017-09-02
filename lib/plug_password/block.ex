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
    password = conn |> fetch_password

    options[:passwords]
    |> Enum.member?(password)
    |> handle_authentication(conn)
  end

  defp fetch_password(conn), do: conn.cookies["plug_password"] || conn.body_params["password"]

  @doc """
  Handles authentication

  First params say if user is authenticated, second in user connection
  """
  defp handle_authentication(true, conn) do
    conn
    |> put_resp_cookie("plug_password", fetch_password(conn))
  end
  defp handle_authentication(false, conn) do
    send_resp(conn, 401, PlugPassword.Template.template)
    |> halt
  end
end
