defmodule PlugPassword.BlockTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule DemoPlug do
    defmacro __using__(args) do
      quote bind_quoted: [args: args] do
        use Plug.Builder
        plug(Plug.Parsers, parsers: [:urlencoded])
        plug(:fetch_cookies)
        plug(PlugPassword.Block, args)
        plug(:index)
        defp index(conn, _opts), do: conn |> send_resp(200, "OK")
      end
    end
  end

  describe "test with only passwords set" do
    defmodule SampleServer do
      use DemoPlug, passwords: ["hello", "world"]
    end

    test "no password in cookie or params provided" do
      conn =
        conn(:get, "/")
        |> SampleServer.call([])

      assert conn.status == 401
      assert conn.halted == true
    end

    test "password in body params provided" do
      conn =
        conn(:get, "/", %{password: "hello"})
        |> SampleServer.call([])

      assert conn.status == 302
      assert conn.cookies["plug_password"] == "hello"
    end

    test "password in connection cookies set" do
      conn =
        conn(:get, "/")
        |> put_resp_cookie("plug_password", "hello")
        |> SampleServer.call([])

      assert conn.status == 200
      assert conn.cookies["plug_password"] == "hello"
      assert conn.resp_body == "OK"
    end
  end

  describe "test with passwords and template set" do
    defmodule SampleTemplate do
      @behaviour PlugPassword.Template.Behaviour

      def template do
        """
        Custom Template
        """
      end
    end

    defmodule SampleServerWithCustomTemplate do
      use DemoPlug, passwords: ["hello", "world"], template: SampleTemplate
    end

    test "with template provided" do
      conn =
        conn(:get, "/")
        |> SampleServerWithCustomTemplate.call([])

      assert conn.status == 401
      assert conn.resp_body == "Custom Template\n"
    end
  end

  describe "test with passwords and path whitelist" do
    defmodule SampleServerWithWhitelist do
      use DemoPlug, passwords: ["hello", "world"], path_whitelist: ~r/\/users/
    end

    test "test with whitelisted path" do
      conn =
        conn(:get, "/users")
        |> SampleServerWithWhitelist.call([])

      assert conn.status == 200
      assert conn.resp_body == "OK"
    end

    test "test with not whitelisted path" do
      conn =
        conn(:get, "/")
        |> SampleServerWithWhitelist.call([])

      assert conn.status == 401
      assert conn.resp_body != "OK"
    end
  end

  describe "tests with password and ip whitelist" do
    defmodule SampleServerWithIPWhitelist do
      use DemoPlug, password: ["hello", "world"], ip_whitelist: ["127.0.0.1"]
    end

    test "test with whitelisted ip" do
      conn =
        conn(:get, "/")
        |> SampleServerWithIPWhitelist.call([])

      assert conn.status == 200
      assert conn.resp_body == "OK"
    end
  end

  describe "test with password and custom rule" do
    defmodule Authentication do
      def check_user_agent(conn) do
        user_agent =
          conn.req_headers
          |> Map.new()
          |> Map.get("user-agent")

        ["facebook", "github", "twitter"]
        |> Enum.member?(user_agent)
      end
    end

    defmodule SampleServerWithCustomRule do
      use DemoPlug,
        password: ["hello", "world"],
        custom_rule: &Authentication.check_user_agent/1
    end

    test "test with custom rule" do
      conn =
        conn(:get, "/")
        |> put_req_header("user-agent", "facebook")
        |> SampleServerWithCustomRule.call([])

      assert conn.status == 200
      assert conn.resp_body == "OK"
    end
  end
end