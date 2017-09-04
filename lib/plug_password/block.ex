defmodule PlugPassword.Block do
  @moduledoc """
  Plug used to add simple authentication.

  Options should be provided with at least passwords field.

  Possible options:
  * `:passwords` - list of passwords that should allow users to pass authentication
  * `:template` - module which implement PlugPassword.Template.Behaviour
  * `:path_whitelist` - regex which will be used to check if path is whitelisted
  """
  import Plug.Conn

  def init([passwords: _, template: _] = options), do: options
  def init(options) do
    List.keystore(options, :template, 0, {:template, PlugPassword.Template})
  end
  
  @doc """
  Checks if password is matching.

  If password will match or is already set in cookie then it will continue to
  pipe connection. Otherwise it will render form.
  """
  def call(conn, options) do
    if already_authenticated?(conn, options) || path_whitelisted?(conn, options) do
      conn
    else
      options[:passwords]
      |> Enum.member?(conn.body_params["password"])
      |> handle_authentication(conn, options)
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

  defp path_whitelisted?(conn, options) do
    if Keyword.has_key?(options, :path_whitelist) do
      options[:path_whitelist] |> Regex.match?(conn.request_path)
    else
      false
    end
  end

  defp handle_authentication(true, conn, _) do
    conn
    |> put_resp_cookie("plug_password", fetch_password(conn))
    |> put_resp_header("location", "/")
    |> send_resp(conn.status || 302, "")
    |> halt
  end
  defp handle_authentication(false, conn, options) do
    conn
    |> put_resp_content_type("text/html", "UTF-8")
    |> send_resp(401, options[:template].template)
    |> halt
  end
end
