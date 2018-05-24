defmodule MiniEqcTest do
  use ExUnit.Case
  use EQC.ExUnit

  property "Reverse String" do
    forall string <- utf8() do
      ensure(String.reverse(String.reverse(string)) == string)
    end
  end

  property "List vs Enum sequence generation" do
    forall {m, n} <- {int(), int()} do
      ensure(:lists.seq(m, n) == Enum.to_list(m..n))
    end
  end

  property "Reversing a list using Enum.reverse" do
    forall l <- list(int()) do
      ensure(Enum.reverse(Enum.reverse(l)) == l)
    end
  end
end
