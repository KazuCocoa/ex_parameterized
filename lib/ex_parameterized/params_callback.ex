defmodule ExUnit.Parameterized.ParamsCallback do
  @moduledoc false

  @spec test_with_params(bitstring, any, fun, [tuple]) :: any
  defmacro test_with_params(desc, context, fun, params_ast) do
    ast = Keyword.get(params_ast, :do, nil)

    case ast do
      # for Map
      [{:{}, _, [{:%{}, _, _}]}] ->
        ast |> do_test_with(desc, context, fun)
      {:@, _, [{atom, _, _}]} -> # for @param
        quote do
          attr = Module.get_attribute(unquote(__CALLER__.module), unquote(atom))
                 |> Macro.escape

          # [{:test, [],
          #   ["'bad': number of 0",
          #     [do: {{:., [],
          #       [#Function<1.14669326 in file:test/ex_parameterized_test.exs>]}, [],
          #         [1]}]]}]
          do_test_with(attr, unquote(desc), unquote(fun))
          # If we can run the above AST, test will run.
        end
      _ ->
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

  def do_test_with(ast, desc, context, fun) do
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

  defp param_with_index(list) do
    Enum.zip(list, 0..Enum.count(list))
  end
end
