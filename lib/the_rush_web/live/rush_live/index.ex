defmodule TheRushWeb.RushLive.Index do
  use TheRushWeb, :live_view

  alias TheRush.Stats

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      assign(
        socket,
        displaying_rushes: 0,
        first_load: true,
        total_rushes_to_display: Stats.get_total_rushes_to_display(""),
        page_options: %{page: 1, per_page: rushes_per_page()},
        options: Map.merge(%{player: ""}, %{sort_by: :player, sort_order: :asc})
      ), temporary_assigns: [rushes: []]
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    player = params["player"] || ""
    sort_by = (params["sort_by"] || "player") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()

    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    socket =
      socket
      |> assign(
        options: Map.merge(%{player: player}, sort_options),
        displaying_rushes: 0,
        total_rushes_to_display: Stats.get_total_rushes_to_display(player),
        page_options: %{page: 1, per_page: rushes_per_page()},
        matches: []
      )
      |> load_rushes()

      case socket.assigns.total_rushes_to_display do
        0 ->
          socket =
            socket
            |> put_flash(:info, "No players found with name \"#{player}\".")
            |> assign(rushes: %{})

          {:noreply, socket}

        _ ->
          {:noreply, socket}
      end
  end

  def handle_event("player-name", %{"player" => player}, socket) do
    {:noreply, assign(socket, matches: Stats.get_players_names(player))}
  end

  @impl true
  def handle_event("player-search", %{"player" => player}, socket) do
    {:noreply, push_patch(
      assign(socket, total_rushes_to_display: Stats.get_total_rushes_to_display(player)),
      to: Routes.rush_index_path(
        socket,
        :index,
        player: player,
        sort_by: socket.assigns.options.sort_by,
        sort_order: socket.assigns.options.sort_order
      )
    )}
  end

  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> assign(page_options: %{page: socket.assigns.page_options.page + 1, per_page: rushes_per_page()})
      |> load_rushes()
    {:noreply, socket}
  end

  defp load_rushes(socket) do
    page_options = %{page: socket.assigns.page_options.page, per_page: rushes_per_page()}
    sort_options = %{sort_by: socket.assigns.options.sort_by, sort_order: socket.assigns.options.sort_order}
    criteria = [player: socket.assigns.options.player, page_options: page_options, sort: sort_options]

    assign(socket,
      rushes: list_rushes(criteria),
      displaying_rushes: Stats.count_rushes(criteria) + socket.assigns.displaying_rushes
    )
  end

  defp list_rushes(criteria) do
    Stats.list_rushes(criteria)
  end

  defp sort_action(socket, text, sort_by, options) do
    text =
      if sort_by == options.sort_by do
        text <> order_sign(options.sort_order)
      else
        text
      end

    live_patch text,
      to: Routes.rush_index_path(
        socket,
        :index,
        player: options.player,
        sort_by: sort_by,
        sort_order: toggle_sort_order(options.sort_order)
      )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc

  defp order_sign(:asc), do: " (Asc)"
  defp order_sign(:desc), do: " (Desc)"

  defp rushes_per_page, do: 50
end
