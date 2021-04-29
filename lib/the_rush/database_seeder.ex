defmodule TheRush.DatabaseSeeder do
  @moduledoc """
  This module contains the logic to read json files and insert in database.
  """

  require Logger
  alias TheRush.Stats.Rush
  alias TheRush.Repo

  @doc """
  Get all JSON files in "priv/repo/seeds" directory and invoke process_file for each of them.
  """
  def load_rushes do
    Path.wildcard("priv/repo/seeds/*.json")
    |> Enum.each(&process_files/1)
  end

  # Reads content from the given `file_name`, validates content and insert to the database
  defp process_files(file_name) do
    # using with/1 to avoid nested case statements
    with {:ok, content} <- File.read(file_name),
      {:ok, json_content} <- Poison.decode(content) do
        Enum.map(json_content, &validate_rush/1)
        |> bulk_insert
    else
      _ ->
        "Unable to load #{file_name} file"
        |> Logger.error
    end
  end

  # Validates the content from the given `rush` map, returning its changeset
  defp validate_rush(rush) do
    Rush.changeset(%Rush{}, Rush.parse_values(rush))
  end

  # Inserts received `changesets` to the database in a single transaction
  defp bulk_insert(changesets) do
    changesets
    |> Enum.with_index
    |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
      Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
    end)
    |> Repo.transaction(timeout: 300000)
  end
end
