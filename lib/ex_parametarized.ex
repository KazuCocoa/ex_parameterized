defmodule ExUnit.Parametarized do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import ExUnit.Parametarized.Params
    end
  end
end
