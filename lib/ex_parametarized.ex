defmodule ExUnit.Parametarized do
  @moduledoc """
  ExUnit.Parametarized support parametarized test with ExUnit.
  Macro of `test_with_params` run standard `test` macro in it.

  ## Examples

  You can run parametarized test with a `test_with_params` macro:

    defmodule MyExample.Test do
      use ExUnit.Case, async: true
      use ExUnit.Parametarized

      test_with_params "describe description1",
        fn (a, b, expected) ->
          assert a + b == expected
        end do
          [
            {1, 2, 3}
          ]
      end

      test_with_params "describe description2",
        fn (a, b, expected) ->
          assert a <> " and " <> b == expected
        end do
          [
            {"dog",   "cats",  "dog and cats"},
            {"hello", "world", "hello and world"}
          ]
      end

      test_with_params "add description for each params",
        fn (a, b, expected) ->
          str = a <> " and " <> b
          assert str == expected
        end do
          [
            "description for param1": {"dog", "cats", "dog and cats"},
            "description for param2": {"hello", "world", "hello and world"}
          ]
      end
    end

  Tun each test cases with line number suffix.
  So, if you failed test, then you can see which parameter is failed.

    defmodule MyExample.Test do
      use ExUnit.Case, async: true
      use ExUnit.Parametarized

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

    1) test add params_line10 (MyExample.Test)
       test/my_example_test.exs:5
       Assertion with == failed
       code: a + b == expected
       lhs:  2
       rhs:  3
       stacktrace:
         test/ex_parametarized_test.exs:5
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import ExUnit.Parametarized.Params
    end
  end
end
