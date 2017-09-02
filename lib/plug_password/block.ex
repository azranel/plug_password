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
    if already_authenticated?(conn, options) do
      conn
    else
      options[:passwords]
      |> Enum.member?(conn.body_params["password"])
      |> handle_authentication(conn)
    end
  end

  defp fetch_password(conn) do
    password_from_cookies(conn) || conn.body_params["password"]
  end

  defp password_from_cookies(conn), do: fetch_cookies(conn).cookies["plug_password"]

  defp already_authenticated?(conn, options) do
    cookie_password = password_from_cookies(conn)
    cookie_password && Enum.member?(options[:passwords], cookie_password)
  end

  defp handle_authentication(true, conn) do
    conn = conn
    |> put_resp_cookie("plug_password", fetch_password(conn))
    |> put_resp_header("location", "/")
    |> send_resp(conn.status || 302, "text/html")
  end
  defp handle_authentication(false, conn) do
    conn
    |> put_resp_content_type("text/html", "UTF-8")
    |> send_resp(401, PlugPassword.Template.template)
    |> halt
  end
end
