defmodule TwittercloneWeb.PostLive.Index do
  use TwittercloneWeb, :live_view

  alias Twitterclone.Timeline
  alias Twitterclone.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :posts, Timeline.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect(socket.assigns.live_action, label: "Live Action")  # Debugging line
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({TwittercloneWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    posts = [post | socket.assigns.posts] |> Enum.sort_by(&(&1.inserted_at), :desc)
    {:noreply, assign(socket, :posts, posts)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    posts = Enum.reject(socket.assigns.posts, fn p -> p.id == post.id end)
    {:noreply, assign(socket, :posts, posts)}
  end

  @impl true
  def handle_event("like", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.increment_likes(post)

    posts = update_post(socket.assigns.posts, post.id, &(%{&1 | likes_count: &1.likes_count + 1}))
    {:noreply, assign(socket, :posts, posts)}
  end

  @impl true
  def handle_event("reply", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.increment_replies(post)

    posts = update_post(socket.assigns.posts, post.id, &(%{&1 | replies_count: &1.replies_count + 1}))
    {:noreply, assign(socket, :posts, posts)}
  end

  defp update_post(posts, id, fun) do
    Enum.map(posts, fn post ->
      if post.id == id, do: fun.(post), else: post
    end)
  end
end
