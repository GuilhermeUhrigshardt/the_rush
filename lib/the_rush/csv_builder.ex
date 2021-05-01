defmodule TheRush.CsvBuilder do
  alias TheRush.Stats.Rush

  # Returns a string that can be used as .csv content
  def generate_csv(rushes) do
    header =
      Rush.csv_header

      rushes =
      rushes
      |> Enum.map(&get_row(&1, header))
      |> Enum.join("\r\n")

    header =
      header
      |> Enum.join(",")

    Enum.join([header,rushes], "\r\n")
  end

  # Returns a single row based on a given `rush`, using `headers` to extract values
  defp get_row(rush, header) do
      header
      |> Enum.map(&Map.get(rush, &1))
      |> Enum.map(&to_binary(&1))
      |> Enum.join(",")
  end

  # Transforms booleans and floats to integer, since those values cannot be used in `Enum.join/2`
  defp to_binary(value) do
    cond do
      is_boolean(value) ->
        case value do
          true ->
            "Yes"
          _ ->
            "No"
        end
      is_float(value) ->
        Float.to_string(value)
      true ->
        value
    end
  end
end
