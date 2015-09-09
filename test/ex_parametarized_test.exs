defmodule ExParametarizedTest do
  use ExUnit.Case
  use ExUnit.Parametarized

  test_with_params "description",
    fn (a, b, expected) ->
      assert a + b == expected
    end do
      [
        {1, 2, 3}
      ]
    end

  test_with_params "description",
    fn (a, b, expected) ->
      assert a <> " and " <> b == expected
    end do
      [
        {"dog", "cats", "dog and cats"},
        {"hello", "world", "hello and world"}
      ]
    end
end
