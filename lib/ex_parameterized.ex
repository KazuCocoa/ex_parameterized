defmodule ExUnit.Parameterized do
  @moduledoc """
  ExUnit.Parameterized support parameterized test with ExUnit.
  Macro of `test_with_params` run standard `test` macro in it.

  ## Examples

  You can run parameterized test with a `test_with_params` macro:

      defmodule MyExample.Test do
        use ExUnit.Case, async: true
        use ExUnit.Parameterized

        setup do
          {:ok, [value: 1]}
        end

        test_with_params "describe description",
          fn (a, b, expected) ->
            assert a + b == expected
          end do
            [
              {1, 2, 3}
            ]
        end

        test_with_params "mixed no desc and with desc for each params",
          fn (a, b, expected) ->
            str = a <> " and " <> b
            assert str == expected
          end do
            [
              {"dog", "cats", "dog and cats"}, # no description
              "description for param2": {"hello", "world", "hello and world"} # with description
            ]
        end

        # support Callback as `context`
        test_with_params "add params with context", context,
          fn (a, b, expected) ->
            assert a + b == expected
          end do
            [
              {context[:value], 2, 3}
            ]
        end

        # Be able to use enum as parameters
        test_with_params "ast from enum",
          fn (a) ->
            assert a == ["a", "b"]
          end do
            Enum.map([{["a", "b"]}], fn (x) -> x end)
        end
      end

  Each test cases have a number suffix when run them.
  So, if you failed test, then you can see which parameter is failed.

      defmodule MyExample.Test do
        use ExUnit.Case, async: true
        use ExUnit.Parameterized

        test_with_params "describe description1",
          fn (a, b, expected) ->
            assert a + b == expected
          end do
            [
              {1, 1, 3}
            ]
        end
      end

  The result is...

      1) test 'add params': numbr of 1 (MyExample.Test)
         test/my_example_test.exs:5
         Assertion with == failed
         code: a + b == expected
         lhs:  2
         rhs:  3
         stacktrace:
           test/ex_parameterized_test.exs:5


  You can skip test with `@tag :skip` or `@tag skip: "If failed to skip, fail test"`.
  (Require Elixir 1.1.0)

      defmodule MyExample.Test do
        use ExUnit.Case, async: true
        use ExUnit.Parameterized

        @tag skip: "If failed to skip, fail test"
        test_with_params "skipped test",
          fn (a) ->
            assert a == true
          end do
            [
              {false},
            ]
        end
      end
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import ExUnit.Parameterized.Params
      import ExUnit.Parameterized.ParamsCallback
    end
  end
end
