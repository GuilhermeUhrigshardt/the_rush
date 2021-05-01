defmodule TheRush.CsvBuilderTest do
  use ExUnit.Case

  @valid_rush [%TheRush.Stats.Rush{attempts: 205, attempts_per_game: 12.8, first_downs: 49, first_downs_percentage: 23.9, forty_plus_yards: 2, fumbles: 2, id: 10, inserted_at: ~N[2021-04-29 16:54:14], longest: 75, player: "Mark Ingram", position: "RB", team: "NO", touchdowns: 6, twenty_plus_yards: 4, updated_at: ~N[2021-04-29 16:54:14], was_longest_touchdown: true, yards_average: 5.1, yards_per_game: 65.2, yards_total: 1043}]
  @valid_rush_csv "player,team,position,attempts,attempts_per_game,yards_total,yards_average,yards_per_game,touchdowns,longest,was_longest_touchdown,first_downs,first_downs_percentage,twenty_plus_yards,forty_plus_yards,fumbles\r\nMark Ingram,NO,RB,205,12.8,1043,5.1,65.2,6,75,Yes,49,23.9,4,2,2"

  test "convert rush to csv" do
    assert TheRush.CsvBuilder.generate_csv(@valid_rush) == @valid_rush_csv
  end
end
