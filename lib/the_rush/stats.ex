defmodule TheRush.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false

  alias TheRush.Repo
  alias TheRush.Stats.Rush

  @doc """
  Returns the list of rushes.

  ## Examples

      iex> TheRush.Stats.list_rushes()
      [%Rush{}, ...]

  """
  def list_rushes do
    Repo.all(Rush)
  end

  @doc """
  Returns the list of rushes based on the given `criteria`. `criteria` is a keyword list and must contain `player`, `page_options` and `sort`.

  ## Examples

      iex> TheRush.Stats.list_rushes([player: "Tony Romo", page_options: %{page: 1, per_page: 50}, sort: %{sort_by: :player, sort_order: :asc}])
      [%Rush{}, ...]
  """
  def list_rushes([player: player_name, page_options: %{page: page, per_page: per_page}, sort: %{sort_by: sort_by, sort_order: sort_order}]) do
    wild_card_player_name = get_wild_card_player_name(player_name)

    from(
      r in Rush,
      where: ilike(r.player, ^wild_card_player_name),
      offset: ^((page - 1) * per_page),
      limit: ^per_page,
      order_by: [{^sort_order, ^sort_by}]
    )
    |> Repo.all
  end

  def list_rushes(%{"options" => %{"player" => player_name, "sort_by" => sort_by, "sort_order" => sort_order}}) do
    wild_card_player_name = get_wild_card_player_name(player_name)
    sort_order = String.to_atom(sort_order)
    sort_by = String.to_atom(sort_by)

    from(
      r in Rush,
      where: ilike(r.player, ^wild_card_player_name),
      order_by: [{^sort_order, ^sort_by}]
    )
    |> Repo.all
  end

  @doc """
  Returns the the total number of rushesin the database.

  ## Examples

      iex> TheRush.Stats.count_rushes()
      348
  """
  def count_rushes do
    Repo.aggregate(Rush, :count, :id)
  end

  @doc """
  Returns the the number of rushes that would be returned with the given the `criteria`.

  ## Examples

      iex> TheRush.Stats.count_rushes([player: "Tony Romo", page_options: %{page: 1, per_page: 50}, sort: %{sort_by: :player, sort_order: :asc}])
      0
  """
  def count_rushes([player: player, page_options: page_options, sort: _]) do
    wild_card_player_name =
      "%#{player
        |> String.replace("%", "")
        |> String.replace("_", "")
      }%"

    %{page: page, per_page: per_page} = page_options

    from(
      r in Rush,
      where: ilike(r.player, ^wild_card_player_name),
      offset: ^((page - 1) * per_page),
      limit: ^per_page
    )
    |> Repo.all
    |> length
  end

  @doc """
  Returns the the total number of rushes that would be returned when searching for a specific `player`.

  ## Examples

      iex> TheRush.Stats.get_total_rushes_to_display("Tony Romo")
      0
  """
  def get_total_rushes_to_display(player) do
    wildcard_player_name =
    "%#{player
    |> String.replace("%", "")
    |> String.replace("_", "")
    }%"

    from(r in Rush,
      where: ilike(r.player, ^wildcard_player_name),
      select: count(r.id)
    )
    |> Repo.all
    |> List.first
  end

  @doc """
  Gets a single rush.

  Raises `Ecto.NoResultsError` if the Rush does not exist.

  ## Examples

      iex> get_rush!(123)
      %Rush{}

      iex> get_rush!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rush!(id), do: Repo.get!(Rush, id)

  @doc """
  Returns the list of distinct players that matches the given `player_name`.

  ## Examples

      iex> get_players_names("mark")
      ["Mark Ingram", "Mark Sanchez"]
  """
  def get_players_names(player_name) do
    wildcard_player_name = "%#{
      player_name
      |> String.replace("%", "")
      |> String.replace("_", "")
    }%"

    from(r in Rush,
      where: ilike(r.player, ^wildcard_player_name),
      distinct: r.player,
      select: r.player
    )
    |> Repo.all
  end

  @doc """
  Creates a rush.

  ## Examples

      iex> create_rush(%{field: value})
      {:ok, %Rush{}}

      iex> create_rush(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rush(attrs \\ %{}) do
    %Rush{}
    |> Rush.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rush.

  ## Examples

      iex> update_rush(rush, %{field: new_value})
      {:ok, %Rush{}}

      iex> update_rush(rush, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rush(%Rush{} = rush, attrs) do
    rush
    |> Rush.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rush.

  ## Examples

      iex> delete_rush(rush)
      {:ok, %Rush{}}

      iex> delete_rush(rush)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rush(%Rush{} = rush) do
    Repo.delete(rush)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rush changes.

  ## Examples

      iex> change_rush(rush)
      %Ecto.Changeset{data: %Rush{}}

  """
  def change_rush(%Rush{} = rush, attrs \\ %{}) do
    Rush.changeset(rush, attrs)
  end

  # Always setting wild card to players names to avoid SQL injection
  defp get_wild_card_player_name(player_name) do
    "%#{
      player_name
      |> String.replace("%", "")
      |> String.replace("_", "")
    }%"
  end
end
