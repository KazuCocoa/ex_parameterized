defmodule ExUnit.Parameterized.ParamsCallback do
  @moduledoc false

  @spec test_with_params(bitstring, any, fun ,[tuple]) :: any
  defmacro test_with_params(desc, context, fun, params_ast) do
    a = try do
      {params, _} = Code.eval_quoted params_ast
      params
    rescue
      _ ->
        params_ast
    end

    Keyword.get(params, :do, nil)
    |> param_with_index
    |> Enum.map(fn(test_param)->
         test_with(desc, context, fun, test_param)
       end)

  end

  defp test_with(desc, context, fun, {{param_desc, {_, _, values}}, num}) when is_atom(param_desc) do
    run("'#{desc}': '#{param_desc}': number of #{num}", context, fun, values)
  end

  # Quote literals case : http://elixir-lang.org/docs/master/elixir/Kernel.SpecialForms.html#quote/2
  defp test_with(desc, context, fun, {{param_desc, values}, num}) when is_atom(param_desc) do
    run("'#{desc}': '#{param_desc}': number of #{num}", context, fun, Tuple.to_list(values))
  end

  defp test_with(desc, context, fun, {{_, _, values}, num}), do: run("'#{desc}': number of #{num}", context, fun, values)

  # Quote literals case : http://elixir-lang.org/docs/master/elixir/Kernel.SpecialForms.html#quote/2
  defp test_with(desc, context, fun, {values, num}), do: run("'#{desc}': number of #{num}", context, fun, Tuple.to_list(values))

  defp run(desc, context, fun, params) do
    quote do
      test unquote(desc), unquote(context), do: unquote(fun).(unquote_splicing(params))
    end
  end

  defp param_with_index(list) do
    Enum.zip list, 0..Enum.count(list)
  end
end
