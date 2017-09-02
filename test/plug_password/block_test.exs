defmodule PlugPassword.BlockTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule DemoPlug do
    defmacro __using__(args) do
      quote bind_quoted: [args: args] do
        use Plug.Builder
        plug Plug.Parsers, parsers: [:urlencoded]
        plug :fetch_cookies
        plug PlugPassword.Block, args
        plug :index
        defp index(conn, _opts), do: conn |> send_resp(200, "OK")
      end
    end
  end

  describe "test with only passwords set" do
    defmodule SampleServer do
      use DemoPlug, passwords: ["hello", "world"]
    end

    test "no password in cookie or params provided" do
      conn = conn(:get, "/")
      |> SampleServer.call([])

      assert conn.status == 401
      assert conn.halted == true
    end

    test "password in body params provided" do
      conn = conn(:get, "/", %{ password: "hello" })
      |> SampleServer.call([])

      assert conn.status == 200
      assert conn.cookies["plug_password"] == "hello"
      assert conn.resp_body == "OK"
    end

    test "password in connection cookies set" do
      conn = conn(:get, "/")
      |> put_resp_cookie("plug_password", "hello")
      |> SampleServer.call([])

      assert conn.status == 200
      assert conn.cookies["plug_password"] == "hello"
      assert conn.resp_body == "OK"
    end
  end
end
