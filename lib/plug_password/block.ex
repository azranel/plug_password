defmodule PlugPassword.Block do
  @moduledoc """
  Plug used to add simple authentication.

  Options should be provided with at least passwords field.
  """
  import Plug.Conn

  def init(options), do: options

  @doc """
  Checks if password is matching.

  If password will match or is already set in cookie then it will continue to
  pipe connection. Otherwise it will render form.
  """
  def call(conn, options) do
    password = conn |> fetch_password

    options[:passwords]
    |> Enum.member?(password)
    |> handle_authentication(conn)
  end

  defp fetch_password(conn), do: conn.cookies["plug_password"] || conn.body_params["password"]

  defp handle_authentication(true, conn) do
    conn
    |> put_resp_cookie("plug_password", fetch_password(conn))
  end
  defp handle_authentication(false, conn) do
    conn
    |> put_resp_content_type("text/html", "UTF-8")
    |> send_resp(401, PlugPassword.Template.template)
    |> halt
  end
end
