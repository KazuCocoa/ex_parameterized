defmodule ExUnit.Parametarized.Params do
  @moduledoc false

  defmacro test_with_params(desc, fun, params) do
    Keyword.get(params, :do, nil)
    |> Enum.map(fn({_, lines, values})->
         quote do
           test unquote("#{desc}_line#{Dict.get(lines, :line)}") do
             unquote(fun).(unquote_splicing(values))
           end
         end
       end)
  end
end
