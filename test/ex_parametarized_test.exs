defmodule ExParametarizedTest do
  use ExUnit.Case, async: true
  use ExUnit.Parametarized

  # AST of "ast format when one param" test is the bellow.
  # {:test_with_params,
  #  [context: ExParametarizedTest, import: ExUnit.Parametarized.Params],
  #  ["ast test",
  #   {:fn, [],
  #    [{:->, [],
  #      [[{:a, [], ExParametarizedTest}],
  #       {:==, [context: ExParametarizedTest, import: Kernel],
  #        [{:a, [], ExParametarizedTest}, "test"]}]}]},
  #   [do: [{:{}, [], ["test"]}]]]}
  test "ast format when one param" do
    import ExUnit.Parametarized.Params
    assert (
      quote do
        test_with_params "ast test", fn (a) -> a == "test" end do
          [{"test"}]
        end
      end
      |> Macro.to_string) == String.strip ~S"""
        test_with_params("ast test", fn a -> a == "test" end) do
          [{"test"}]
        end
        """
  end

  # AST of "ast format when one param" test is the bellow.
  # {:test_with_params,
  #  [context: ExParametarizedTest, import: ExUnit.Parametarized.Params],
  #  ["ast test",
  #   {:fn, [],
  #    [{:->, [],
  #      [[{:a, [], ExParametarizedTest}, {:b, [], ExParametarizedTest}],
  #       {:assert, [context: ExParametarizedTest, import: ExUnit.Assertions],
  #        [{:==, [context: ExParametarizedTest, import: Kernel],
  #          [{:+, [context: ExParametarizedTest, import: Kernel],
  #            [{:a, [], ExParametarizedTest}, {:b, [], ExParametarizedTest}]},
  #           2]}]}]}]}, [do: [{1, 2}]]]}
  test "ast format when two param" do
    import ExUnit.Parametarized.Params
    assert (
      quote do
        test_with_params "ast test", fn (a, b) -> assert a + b == 2 end do
          [{1, 2}]
        end
      end

      |> Macro.to_string) == String.strip ~S"""
        test_with_params("ast test", fn a, b -> assert(a + b == 2) end) do
          [{1, 2}]
        end
        """
  end

  @tag skip: "If failed to skip, test will fail"
  test_with_params "skipped test",
    fn (a) ->
      assert a == true
    end do
      [
        {false},
      ]
  end

  test_with_params "provide one param",
    fn (a) ->
      assert a == 1
    end do
      [
        {1},
        "two values": {1}
      ]
  end

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
