defmodule ExUnit.Parametarized.Params do
  defmacro test_with_params(desc, fun, params) do
    Keyword.get(params, :do, nil)
    |> param_with_index
    |> Enum.map(fn({{_, _, values}, i})->
         quote do
           test unquote("#{desc}_#{i}") do
             unquote(fun).(unquote_splicing(values))
           end
         end
       end)
  end

  defp param_with_index(list) do
    Enum.zip list, 0..Enum.count list
  end
end
