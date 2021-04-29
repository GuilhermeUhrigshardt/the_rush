defmodule TheRush.Repo.Migrations.CreateRushesTable do
  use Ecto.Migration

  def change do
    create table(:rushes) do
      add :player, :string, null: false
      add :team, :string, null: false
      add :position, :string, null: false
      add :attempts, :integer, null: false
      add :attempts_per_game, :float, null: false
      add :yards_total, :integer, null: false
      add :yards_average, :float, null: false
      add :yards_per_game, :float, null: false
      add :touchdowns, :integer, null: false
      add :longest, :integer, null: false
      add :was_longest_touchdown, :boolean, default: false, null: false
      add :first_downs, :integer, null: false
      add :first_downs_percentage, :float, null: false
      add :twenty_plus_yards, :integer, null: false
      add :forty_plus_yards, :integer, null: false
      add :fumbles, :integer, null: false

      timestamps()
    end

    # Creating indexes to improve performance in the fields that will be sorted/filtered
    create index(:rushes, :player)
    create index(:rushes, :yards_total)
    create index(:rushes, :longest)
    create index(:rushes, :touchdowns)
  end
end
