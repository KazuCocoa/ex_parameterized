defmodule ExUnit.Parametarized.Params do
  @moduledoc false

  defmacro test_with_params(desc, fun, params) do
    Keyword.get(params, :do, nil)
    |> Enum.map( fn(test_param)->
         case test_param do
           {param_desc, {_, lines, values}} ->
             test_with(desc, fun, param_desc, lines, values)
           {_, lines, values} ->
             test_with(desc, fun, lines, values)
         end
       end)
  end

  defp test_with(desc, fun, lines, values) do
    quote do
      test unquote("#{desc}_line#{Dict.get(lines, :line)}") do
        unquote(fun).(unquote_splicing(values))
      end
    end
  end

  defp test_with(desc, fun, param_desc, lines, values) do
    quote do
      test unquote("#{desc}_#{param_desc}_line#{Dict.get(lines, :line)}") do
        unquote(fun).(unquote_splicing(values))
      end
    end
  end

end
