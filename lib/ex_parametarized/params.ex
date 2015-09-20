defmodule ExUnit.Parametarized.Params do
  @moduledoc false

  defmacro test_with_params(desc, fun, params) do
    Keyword.get(params, :do, nil)
    |> param_with_index
    |> Enum.map(fn(test_param)->
         test_with(desc, fun, test_param)
       end)
  end

  defp test_with(desc, fun, {{param_desc, {_, _, values}}, num}) when is_atom(param_desc) do
    run("#{desc}_#{param_desc}_num#{num}", fun, values)
  end

  defp test_with(desc, fun, {{param_desc, values}, num}) when is_atom(param_desc) do
    run("#{desc}_#{param_desc}_num#{num}", fun, Tuple.to_list(values))
  end

  defp test_with(desc, fun, {{_, _, values}, num}) do
    run("#{desc}_num#{num}", fun, values)
  end

  defp test_with(desc, fun, {values, num}) do
    run("#{desc}_num#{num}", fun, Tuple.to_list(values))
  end

  defp run(desc, fun, params) do
    quote do
      test unquote(desc), do: unquote(fun).(unquote_splicing(params))
    end
  end

  defp param_with_index(list) do
    Enum.zip list, 0..Enum.count(list)
  end
end
