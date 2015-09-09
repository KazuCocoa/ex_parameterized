defmodule ExUnit.Parametarized do

  @moduledoc """
  ExUnit.Parametarized support parametarized test with ExUnit.
  Macro of `test_with_params` run standard `test` macro in it.

  ## Examples

  You can run parametarized test with a `test_with_params` macro:

    defmodule MyExample.Test do
      use ExUnit.Case, async: true
      use ExUnit.Parametarized

      test_with_params "describe description",
        fn (a, b, expected) ->
          assert a + b == expected
        end do
          [
            {1, 2, 3}
          ]
      end

      test_with_params "describe description",
        fn (a, b, expected) ->
          assert a <> " and " <> b == expected
        end do
          [
            {"dog",   "cats",  "dog and cats"},
            {"hello", "world", "hello and world"}
          ]
      end
    end
  """

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import ExUnit.Parametarized.Params
    end
  end
end
