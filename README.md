ExParametarized
===============

## Description

This library support parametarized test with `test_with_params` macro.

## Demo

Clone this repository and run test with `mix test`.
Please see `test/ex_parametarized_test.exs`.

## Usage

Please see module [docs](http://hexdocs.pm/ex_parametarized/overview.html).

## Install

First, add Reporter to your mix.exs dependencies:

```
def deps do
  [
    {:ex_parametarized, "~> 0.3.0"}
  ]
end
```

and run ``$ mix deps.get`.

## QuickUse

Should set `use ExUnit.Parametarized` in module.

```elixir
defmodule MyExampleTest do
  use ExUnit.Case, async: true
  use ExUnit.Parametarized        # Required

  test_with_params "add params",  # description
    fn (a, b, expected) ->        # test case
      assert a + b == expected
    end do
      [
        {1, 2, 3},                 # parameters
        "description": {1, 4, 5},  # parameters with description
      ]
  end
end
```



## Licence

[MIT](https://github.com/KazuCocoa/ex_parametarized/blob/master/LICENSE)
