defmodule MultiplyQuery do
  @input_file_text "Input file name (without extension): "
  @output_file_text "Choose a name to the output file (without extension): "

  defp get_schemas do
    case File.read("schemas.json") do
      {:ok, json} ->
        json
        |> JSON.decode()

      error ->
        error
    end
  end

  defp get_input_query do
    file =
      IO.gets(IO.ANSI.format([:black, :blue, @input_file_text]))
      |> String.trim()

    File.read("input/#{file}.sql")
  end

  def generate do
    case get_schemas() do
      {:ok, schemas} ->
        case get_input_query() do
          {:ok, query} ->
            q =
              schemas
              |> Enum.reduce("", fn schema, acc ->
                "#{acc}#{Regex.replace(~r/per_unity/, query, schema)};\n"
              end)

            output_file_name =
              IO.gets(IO.ANSI.format([:black, :blue, @output_file_text]))
              |> String.trim()

            case File.write("output/#{output_file_name}.sql", q) do
              :ok ->
                {:ok, :success}
              error ->
                {:error, error}
            end
          error ->
            error
        end

      error ->
        error
    end
  end

  def start(_type, _args) do
    case generate() do
      {:ok, _} ->
        :ok
      error ->
        error
    end
  end
end
