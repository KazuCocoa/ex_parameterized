defmodule ExParametarizedTestCaseTest do
  use ExUnit.CaseTemplate

  setup do
    {:ok, [hello: "world", value: 1, bool: false]}
  end
end

defmodule ExParametarizedTestCaseTest.MyTest  do
  use ExParametarizedTestCaseTest, async: true
  use ExUnit.Parametarized

  test_with_params "provide one param with context on test template", context,
    fn (a) ->
      assert a == 1
    end do
      [
        {context[:value]},
        "two values": {context[:value]}
      ]
  end
end
