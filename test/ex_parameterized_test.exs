defmodule ExParameterizedTest do
  use ExUnit.Case
  use ExUnit.Parameterized

  # AST of "ast format when one param" test is the bellow.
  # {:test_with_params,
  #  [context: ExParameterizedTest, import: ExUnit.Parameterized.Params],
  #  ["ast test",
  #   {:fn, [],
  #    [{:->, [],
  #      [[{:a, [], ExParameterizedTest}],
  #       {:==, [context: ExParameterizedTest, import: Kernel],
  #        [{:a, [], ExParameterizedTest}, "test"]}]}]},
  #   [do: [{:{}, [], ["test"]}]]]}
  test "ast format when one param" do
    import ExUnit.Parameterized.Params
    assert (
      quote do
        test_with_params "ast test", fn (a) -> a == "test" end do
          [{"test"}]
        end
      end
      |> Macro.to_string) == String.trim ~S"""
        test_with_params("ast test", fn a -> a == "test" end) do
          [{"test"}]
        end
        """
  end

  # AST of "ast format when one param" test is the bellow.
  # {:test_with_params,
  #  [context: ExParameterizedTest, import: ExUnit.Parameterized.Params],
  #  ["ast test",
  #   {:fn, [],
  #    [{:->, [],
  #      [[{:a, [], ExParameterizedTest}, {:b, [], ExParameterizedTest}],
  #       {:assert, [context: ExParameterizedTest, import: ExUnit.Assertions],
  #        [{:==, [context: ExParameterizedTest, import: Kernel],
  #          [{:+, [context: ExParameterizedTest, import: Kernel],
  #            [{:a, [], ExParameterizedTest}, {:b, [], ExParameterizedTest}]},
  #           2]}]}]}]}, [do: [{1, 2}]]]}
  test "ast format when two param" do
    import ExUnit.Parameterized.Params
    assert (
      quote do
        test_with_params "ast test", fn (a, b) -> assert a + b == 2 end do
          [{1, 2}]
        end
      end

      |> Macro.to_string) == String.trim ~S"""
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

  test_with_params "with map value",
    fn (a) ->
      assert a.b == 1
      assert a.c == 2
    end do
      [
        {%{b: 1, c: 2}},
      ]
  end

  describe "example with shouldi" do
    test_with_params "provide one param",
      fn (a) ->
        assert a == 1
      end do
        [
          {return_one()}, # Can set other functions
          "two values": {1}
        ]
    end
    defp return_one, do: 1

    test_with_params "compare two values",
      fn (a, expected) ->
        assert a == expected
      end do
        [
          {1, 1},
          "two values": {return_hello(), "hello"}  # Can set other functions
        ]
    end
    defp return_hello, do: "hello"

    test_with_params "add params",
      fn (a, b, expected) ->
        assert a + b == expected
      end do
        [
          {1, 2, 3}
        ]
    end
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

  test_with_params "ast from enum",
    fn (a) ->
      assert a == ["a", "b"]
    end do
      Enum.map([{["a", "b"]}], fn (x) -> x end)
  end
end
