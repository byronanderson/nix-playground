defmodule Foo do
  def thing() do
    Enum.map(1..10, fn x -> x + 1 end)
  end
end
