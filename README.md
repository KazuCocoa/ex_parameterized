ExParameterized
===============

[![Build Status](https://travis-ci.org/KazuCocoa/ex_parameterized.svg)](https://travis-ci.org/KazuCocoa/ex_parameterized)
[![](https://img.shields.io/hexpm/v/ex_parameterized.svg?style=flat)](https://hex.pm/packages/ex_parameterized)

## Description

This library support parameterized test with `test_with_params` macro.

### Support
- `test` macro provided by ExUnit.Case and ExUnit.CaseTemplate
- `Callback` like `setup` provided by ExUnit.Callback


## Demo

Clone this repository and run test with `mix test`.
You can see some example in `test/ex_parameterized_*.exs`

## Usage

Please see module [docs](http://hexdocs.pm/ex_parameterized/extra-api-reference.html).

## Install

First, add Reporter to your mix.exs dependencies:

```
def deps do
  [
    {:ex_parameterized, "~> 1.3.1"}
  ]
end
```

and run ``$ mix deps.get`.

## QuickUse

Should set `use ExUnit.Parameterized` in module.

```elixir
defmodule MyExampleTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized        # Required

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

[MIT](https://github.com/KazuCocoa/ex_parameterized/blob/master/LICENSE)
