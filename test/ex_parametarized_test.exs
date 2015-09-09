defmodule ExParametarizedTest do
  use ExUnit.Case, async: true
  use ExUnit.Parametarized

  test_with_params "add params",
    fn (a, b, expected) ->
      assert a + b == expected
    end do
      [
        {1, 2, 3}
      ]
  end

  test_with_params "create wordings",
    fn (a, b, expected) ->
      assert a <> " and " <> b == expected
    end do
      [
        {"dog", "cats", "dog and cats"},
        {"hello", "world", "hello and world"}
      ]
  end

  test_with_params "fail case",
    fn (a, b, expected) ->
      refute a + b == expected
    end do
      [
        {1, 2, 2}
      ]
  end

end
