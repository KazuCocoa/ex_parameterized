defmodule ExUnit.Parameterized.ParamsCallback do
  @moduledoc false

  @spec test_with_params(bitstring, any, fun, [tuple]) :: any
  defmacro test_with_params(desc, context, fun, params_ast) do
    ast = Keyword.get(params_ast, :do, nil)

    case validate_map?(ast) do
      true ->
        ast |> do_test_with(desc, context, fun)
      false ->
        try do
          {params, _} = params_ast |> Code.eval_quoted()

          params
          |> Keyword.get(:do, nil)
          |> do_test_with(desc, context, fun)
        rescue
          _ ->
            ast |> do_test_with(desc, context, fun)
        end
    end
  end

  defp validate_map?(asts, result \\ [])
  defp validate_map?([], result) when is_list(result), do: true
  defp validate_map?([], _), do: false
  defp validate_map?([{:%{}, _, _}], _), do: true
  defp validate_map?(asts, result) when is_list(asts) do
    [head | tail] = asts
    case head do
      {_, _, [{:%{}, _, _}]} ->

        tail |> validate_map?([head|result])
      _ ->
        false
    end
  end
  defp validate_map?(_asts, _result), do: false


  defp do_test_with(ast, desc, context, fun) do
    ast
    |> param_with_index()
    |> Enum.map(fn param ->
      test_with(desc, context, fun, param)
    end)
  end

  defp test_with(desc, context, fun, {{param_desc, {_, _, values}}, num}) when is_atom(param_desc) do
    run("'#{desc}': '#{param_desc}': number of #{num}", context, fun, values)
  end

  # Quote literals case : http://elixir-lang.org/docs/master/elixir/Kernel.SpecialForms.html#quote/2
  defp test_with(desc, context, fun, {{param_desc, values}, num}) when is_atom(param_desc) do
    run("'#{desc}': '#{param_desc}': number of #{num}", context, fun, Tuple.to_list(values))
  end

  defp test_with(desc, context, fun, {{_, _, values}, num}),
    do: run("'#{desc}': number of #{num}", context, fun, values)

  # Quote literals case : http://elixir-lang.org/docs/master/elixir/Kernel.SpecialForms.html#quote/2
  defp test_with(desc, context, fun, {values, num}),
    do: run("'#{desc}': number of #{num}", context, fun, Tuple.to_list(values))

  defp run(desc, context, fun, params) do
    quote do
      test(unquote(desc), unquote(context), do: unquote(fun).(unquote_splicing(params)))
    end
  end

  defp param_with_index(list) when is_list(list) do
    Enum.zip(list, 0..Enum.count(list))
  end
  defp param_with_index(_) do
    raise(ArgumentError, message: "Unsupported format")
  end
end
