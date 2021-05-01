defmodule TheRushWeb.RushController do
  use TheRushWeb, :controller
  alias TheRush.Stats
  alias TheRush.CsvBuilder

  # `params` %{"options" => %{"player" => "", "sort_by" => "player", "sort_order" => "asc"}}
  # Returns the CSV file given the `params`
  def index(conn, params) do
    rushes =
      Stats.list_rushes(params)
      |> CsvBuilder.generate_csv

    send_download(conn, {:binary, rushes}, filename: "stats.csv")
  end
end
