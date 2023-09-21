defmodule FactChecker.HelpersTest do
  use ExUnit.Case
  alias FactChecker.Helpers
  describe "helper functions" do
    test "size_of_map/1 - with map size one or more returns a list with matches or a string of matches" do
      map_size_one = %{"X" => "sam"}
      map_size_many = %{"X" => "3", "Y" => "5"}


      assert Helpers.size_of_map(map_size_one) == ["sam"]
      assert Helpers.size_of_map(map_size_many) == "{X: 3, Y: 5}"
    end

    test "format_list/1 - formats the list into correct writable string" do
      tuple = [{"X", "alex"}, {"Y", "sam"}]
      tuple_two = [{"X", "3"}, {"Y", "5"}]


      assert Helpers.format_list(tuple) =="X: alex, Y: sam"
      assert Helpers.format_list(tuple_two) == "X: 3, Y: 5"
    end

    test "is_variable/1 - returns true if variable and false if not" do
      assert Helpers.is_variable?("X") == true
      assert Helpers.is_variable?("str") == false
    end

    test "validate/1 - removes not needed strings" do
      assert Helpers.validate(["(3,", "4,", "5)\n"]) == ["3", "4", "5"]
      assert Helpers.validate(["(X,", "X,", "Y)"]) == ["X", "X", "Y"]
    end
  end
end
