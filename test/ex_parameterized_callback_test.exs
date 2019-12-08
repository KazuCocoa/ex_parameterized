defmodule ExParameterizedParamsCallbackTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  setup do
    {:ok, [hello: "world", value: 1, bool: false, nil_value: nil]}
  end

  test "ast format when one param with context" do
    import ExUnit.Parameterized.ParamsCallback

    assert (quote do
              test_with_params "ast test", context, fn a -> a == "test" end do
                [{"test"}]
              end
            end)
           |> Macro.to_string() ==
             String.trim(~S"""
             test_with_params("ast test", context, fn a -> a == "test" end) do
               [{"test"}]
             end
             """)
  end

  test "ast format when two param with context" do
    import ExUnit.Parameterized.ParamsCallback

    assert (quote do
              test_with_params "ast test", context, fn a, b -> assert a + b == 2 end do
                [{1, 2}]
              end
            end)
           |> Macro.to_string() ==
             String.trim(~S"""
             test_with_params("ast test", context, fn a, b -> assert(a + b == 2) end) do
               [{1, 2}]
             end
             """)
  end

  @tag skip: "If failed to skip, test will fail"
  test_with_params "skipped test with context", context, fn a ->
    assert a == true
  end do
    [
      {context[:bool]}
    ]
  end

  test_with_params "provide one param with context", context, fn a ->
    assert a == 1
  end do
    [
      {context[:value]},
      "two values": {context[:value]}
    ]
  end

  test_with_params "compare two values with context", context, fn a, expected ->
    assert a == expected
  end do
    [
      # Can set other functions
      {context[:value], return_one()},
      # Can set other functions
      "two values": {context[:hello], return_world()}
    ]
  end

  defp return_one, do: 1
  defp return_world, do: "world"

  test_with_params "add params with context", context, fn a, b, expected ->
    assert a + b == expected
  end do
    [
      {context[:value], 2, 3}
    ]
  end

  test_with_params "create wordings with context", context, fn a, b, expected ->
    str = a <> " and " <> b
    assert str == expected
  end do
    [
      {context[:hello], "cats", "world and cats"},
      {"hello", context[:hello], "hello and world"}
    ]
  end

  test_with_params "fail case with context", context, fn a, b, expected ->
    refute a + b == expected
  end do
    [
      {context[:value], 2, 2}
    ]
  end

  test_with_params "with nil", context, fn expected, a, b ->
    assert a == expected
    assert b == expected
  end do
    [
      {context[:value], 1, 1},
      {context[:nil_value], nil, nil}
    ]
  end

  test_with_params "with map value", context, fn a ->
    assert a.b == 1
    assert a.c == 2
  end do
    [
      {%{b: 1, c: 2}}
    ]
  end

  test_with_params "with two map values", context, fn a ->
    assert a.b == 1
    assert a.c == 2
  end do
    [
      {%{b: 1, c: 2}},
      {%{b: 1, c: 2}}
    ]
  end

  test_with_params "ast from enum", context, fn a ->
    assert a == ["a", "b"]
  end do
    Enum.map([{["a", "b"]}], fn x -> x end)
  end

  test_with_params "ast from enum of maps", context, fn a ->
    assert a == %{b: 1, c: 2}
  end do
    Enum.map([{%{b: 1, c: 2}}], fn x -> x end)
  end

  test_with_params "ast from enum of maps 2", context, fn a ->
    assert a == %{b: 1, c: 2}
  end do
    Enum.map([{%{b: 1, c: 2}}, {%{b: 1, c: 2}}], fn x -> x end)
  end

  test_with_params "add description for each params with context", context, fn a, b, expected ->
    str = a <> " and " <> b
    assert str == expected
  end do
    [
      "description for param1": {context[:hello], "cats", "world and cats"},
      "description for param2": {"hello", context[:hello], "hello and world"}
    ]
  end

  test_with_params "mixed no desc and with desc for each params with context", context, fn a,
                                                                                           b,
                                                                                           expected ->
    str = a <> " and " <> b
    assert str == expected
  end do
    [
      # no description
      {context[:hello], "cats", "world and cats"},
      # with description
      "description for param2": {"hello", context[:hello], "hello and world"}
    ]
  end

  test_with_params "with function", fn p ->
    p
  end do
    make = fn a -> a + 1 end

    [
      {make.(1)}
    ]
  end

  test_with_params "with map as second parameter", context, fn a, m ->
    assert a == "some"
    assert m.a == "world"
  end do
    [
      {"some", %{a: context[:hello], b: 2, c: 3}}
    ]
  end

  test_with_params "nested tuple combination", context, fn a, expected ->
    case a do
      [1, 0] ->
        assert {{1, context[:value]}, 0, []} == expected

      [1, 0, 2] ->
        assert {{1, 1}, 0, [{2, 2}, {2, 2}]} == expected
    end
  end do
    [
      {
        [1, 0],
        {{1, 1}, 0, []}
      },
      {
        [1, 0, 2],
        {{context[:value], 1}, 0, [{2, 2}, {2, 2}]}
      }
    ]
  end
end
