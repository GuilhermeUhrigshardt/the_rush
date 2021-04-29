defmodule TheRush.Stats.Rush do
  @moduledoc false

  # Rush schema

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}

  # Separated "longest_rush" into:
  #   `longest` (integer)
  #   `was_longest_touchdown` (boolean)
  schema "rushes" do
    field :attempts, :integer
    field :attempts_per_game, :float
    field :first_downs, :integer
    field :first_downs_percentage, :float
    field :forty_plus_yards, :integer
    field :fumbles, :integer
    field :longest, :integer
    field :player, :string
    field :position, :string
    field :team, :string
    field :touchdowns, :integer
    field :twenty_plus_yards, :integer
    field :was_longest_touchdown, :boolean, default: false
    field :yards_average, :float
    field :yards_per_game, :float
    field :yards_total, :integer

    timestamps()
  end

  # Added length validations for string fields
  def changeset(rush, attrs) do
    rush
    |> cast(attrs, [:player, :team, :position, :attempts, :attempts_per_game, :yards_total, :yards_average, :yards_per_game, :touchdowns, :longest, :was_longest_touchdown, :first_downs, :first_downs_percentage, :twenty_plus_yards, :forty_plus_yards, :fumbles])
    |> validate_required([:player, :team, :position, :attempts, :attempts_per_game, :yards_total, :yards_average, :yards_per_game, :touchdowns, :longest, :was_longest_touchdown, :first_downs, :first_downs_percentage, :twenty_plus_yards, :forty_plus_yards, :fumbles])
    |> validate_length(:player, min: 1, max: 255)
    |> validate_length(:team, min: 1, max: 255)
    |> validate_length(:position, min: 1, max: 255)
  end

  # Creates a `Rush` map from the given `attrs` map
  def parse_values(attrs) do
    %{}
    |> Map.put_new(:player, Map.fetch!(attrs, "Player"))
    |> Map.put_new(:team, Map.fetch!(attrs, "Team"))
    |> Map.put_new(:position, Map.fetch!(attrs, "Pos"))
    |> Map.put_new(:attempts, to_integer(Map.fetch!(attrs, "Att")))
    |> Map.put_new(:attempts_per_game, to_float(Map.fetch!(attrs, "Att/G")))
    |> Map.put_new(:yards_total, to_integer(Map.fetch!(attrs, "Yds")))
    |> Map.put_new(:yards_average, to_float(Map.fetch!(attrs, "Avg")))
    |> Map.put_new(:yards_per_game, to_float(Map.fetch!(attrs, "Yds/G")))
    |> Map.put_new(:touchdowns, to_integer(Map.fetch!(attrs, "TD")))
    |> Map.put_new(:longest, get_longest(Map.fetch!(attrs, "Lng")))
    |> Map.put_new(:was_longest_touchdown, check_if_logest_was_touchdown(Map.fetch!(attrs, "Lng")))
    |> Map.put_new(:first_downs, to_integer(Map.fetch!(attrs, "1st")))
    |> Map.put_new(:first_downs_percentage, to_float(Map.fetch!(attrs, "1st%")))
    |> Map.put_new(:twenty_plus_yards, to_integer(Map.fetch!(attrs, "20+")))
    |> Map.put_new(:forty_plus_yards, to_integer(Map.fetch!(attrs, "40+")))
    |> Map.put_new(:fumbles, to_integer(Map.fetch!(attrs, "FUM")))
  end

  # Converts the given value to float (can contain commas)
  defp to_float(value) do
    cond do
      is_binary(value) ->
        {float, _} = value
        |> String.replace(",", "")
        |> Float.parse
        float
      true ->
        value
    end
  end

  # Converts the given value to integer (can contain commas)
  defp to_integer(value) do
    cond do
      is_binary(value) ->
        {integer, _} = value
        |> String.replace(",", "")
        |> Integer.parse
        integer
      true ->
        value
    end
  end

  # Converts the given value to integer (can contain char 'T')
  defp get_longest(value) do
    cond do
      is_integer(value) ->
        value
      true ->
        value
        |> String.replace("T", "")
        |> to_integer
    end
  end

  # Converts the given value to boolean (true if contains chat 'T')
  defp check_if_logest_was_touchdown(value) do
    cond do
      is_integer(value) ->
        false
      true ->
        value
        |> String.contains?("T")
    end
  end
end
