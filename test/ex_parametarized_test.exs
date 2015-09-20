defmodule ExParametarizedTest do
  use ExUnit.Case, async: true
  use ExUnit.Parametarized

  test_with_params "compare two values",
    fn (a, expected) ->
      assert a == expected
    end do
      [
        {1, 1},
        "two values": {"hello", "hello"}
      ]
  end

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
      str = a <> " and " <> b
      assert str == expected
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

end
