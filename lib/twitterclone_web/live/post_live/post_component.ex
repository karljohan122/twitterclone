defmodule TwittercloneWeb.PostLive.PostComponent do
  use TwittercloneWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"post-#{@post.id}"} class="flex flex-col bg-white shadow rounded-lg p-4 mb-4 w-full sm:w-1/2 lg:w-1/3 xl:w-1/4">
      <div class="flex-1">
        <h2 class="text-xl font-semibold"><%= @post.username %></h2>
        <p class="text-gray-700"><%= @post.body %></p>
        <div class="mt-2">
          <span class="text-sm text-gray-500">Likes: <%= @post.likes_count %></span>
          <span class="text-sm text-gray-500 ml-4">Replies: <%= @post.replies_count %></span>
        </div>
      </div>
      <div class="mt-4 flex gap-2">
        <.link patch={~p"/posts/#{@post.id}/edit"} class="text-blue-500">Edit</.link>
        <.link
          phx-click={JS.push("delete", value: %{id: @post.id}) |> hide("##{@post.id}")}
          data-confirm="Are you sure?"
          class="text-red-500"
        >
          Delete
        </.link>
      </div>
    </div>
    """
  end
end
