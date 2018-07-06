defmodule ExUnit.Parameterized.Params do
  @moduledoc false

  @spec test_with_params(bitstring, fun, [tuple]) :: any
  defmacro test_with_params(desc, fun, params_ast) do
    ast = Keyword.get(params_ast, :do, nil)

    case validate_map?(ast) do
      true ->
        ast |> do_test_with(desc, fun)

      false ->
        try do
          {params, _} = Code.eval_quoted(params_ast)
          Keyword.get(params, :do, nil) |> do_test_with(desc, fun)
        rescue
          _ ->
            ast |> do_test_with(desc, fun)
        end
    end
  end

  defp validate_map?([]), do: false
  defp validate_map?([{:%{}, _, _}]), do: true
  defp validate_map?({{_, _, [{_, _, [:Enum]}, :map]}, _, ast}), do: validate_map?(ast)
  defp validate_map?(asts) when is_list(asts) do
    [head | _tail] = asts

    case head do
      {:{}, _, [{:%{}, _, _}]} ->
        true
      [{:{}, _, [{:%{}, _, _}]}] ->
        validate_map?(head)
      _ ->
        false
    end
  end

  defp validate_map?(_asts), do: false

  defp do_test_with(ast, desc, fun) do
    ast
    |> param_with_index()
    |> Enum.map(fn param ->
      test_with(desc, fun, param)
    end)
  end

  defp test_with(desc, fun, {{param_desc, {_, _, values}}, num}) when is_atom(param_desc) do
    run("'#{desc}': '#{param_desc}': number of #{num}", fun, values)
  end

  # Quote literals case : http://elixir-lang.org/docs/master/elixir/Kernel.SpecialForms.html#quote/2
  defp test_with(desc, fun, {{param_desc, values}, num}) when is_atom(param_desc) do
    run("'#{desc}': '#{param_desc}': number of #{num}", fun, Tuple.to_list(values))
  end

  defp test_with(desc, fun, {{_, _, values}, num}),
    do: run("'#{desc}': number of #{num}", fun, values)

  defp test_with(desc, fun, {[{:{}, _, [{:%{}, _, values}]}], num}),
    do: run("'#{desc}': number of #{num}", fun, values)

  # Quote literals case : http://elixir-lang.org/docs/master/elixir/Kernel.SpecialForms.html#quote/2
  defp test_with(desc, fun, {values, num}),
    do: run("'#{desc}': number of #{num}", fun, Tuple.to_list(values))

  defp run(desc, fun, params) do
    quote do
      test unquote(desc), do: unquote(fun).(unquote_splicing(params))
    end
  end

  defp param_with_index(list) when is_list(list) do
    Enum.zip(list, 0..Enum.count(list))
  end

  defp param_with_index({_, _, [list, _]}) when is_list(list) do
    Enum.zip(list, 0..Enum.count(list))
  end

  defp param_with_index(_) do
    raise(ArgumentError, message: "Unsupported format")
  end
end
