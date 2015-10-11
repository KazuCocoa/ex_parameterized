ExParametarized
===============

## Description

This library support parametarized test with `test_with_params` macro.

### Support
- `test` macro provided by ExUnit.Case and ExUnit.CaseTemplate
- `Callback` like `setup` provided by ExUnit.Callback


## Demo

Clone this repository and run test with `mix test`.
You can see some example in `test/ex_parametarized_*.exs`

## Usage

Please see module [docs](http://hexdocs.pm/ex_parametarized/extra-api-reference.html).

## Install

First, add Reporter to your mix.exs dependencies:

```
def deps do
  [
    {:ex_parametarized, "~> 0.4.1"}
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
