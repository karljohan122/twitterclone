defmodule TwittercloneWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Twitterclone.Accounts

  def init(default), do: default

  def call(conn, _opts) do
    if Accounts.get_user(conn.assigns.current_user.id) do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> redirect(to: "/login")
      |> halt()
    end
  end
end
