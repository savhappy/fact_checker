defmodule FactChecker.ParserTest do
  use ExUnit.Case
  alias FactChecker.Parser

  describe "parser functions" do
    test "parser/1 - parses the list into a tuple" do
      pattern = ["likes", "X", "sam"]
      pattern_two = ["likes", "X", "Y"]
      pattern_three = ["likes", "X", "X"]


      assert Parser.parser(pattern) == {"likes", :"$1", "sam"}
      assert Parser.parser(pattern_two) == {"likes", :"$1", :"$2"}
      assert Parser.parser(pattern_three) == {"likes", :"$1", :"$1"}
      assert Parser.parser([]) == {}
    end

    test "map_parser/2 - replaces all variables with appropriate atom to pattern match on ets function" do
     map =  %{"X" => 1}
     pattern = ["likes", "X", "X"]

     map_two = %{"X" => 1, "Y" => 2}
     pattern_two = ["make_a_triple", "X", "4", "Y"]


      assert Parser.map_parser(map, pattern) == {"likes", :"$1", :"$1"}
      assert Parser.map_parser(map_two, pattern_two) == {"make_a_triple", :"$1", "4", :"$2"}
      assert Parser.map_parser(%{}, []) == {}
    end

    test "parser_to_write/2 - takes pattern and matched and writes to file" do
      pattern = ["likes", "X", "sam"]
      matched = [{"likes", "alex", "sam"}, {"likes", "sam", "sam"}]

      assert Parser.parser_to_write(pattern, matched) == :ok
     end


    test "compare_lists/2 - with two lists, compares and returns values that don't match" do
      pattern = ["likes", "X", "X"]
      matched = [{"likes", "sam", "sam"}]

      pattern_two =["likes", "X", "sam"]
      matched_two = [{"likes", "alex", "sam"}, {"likes", "sam", "sam"}]


      assert Parser.compare_lists(pattern, matched) == [["sam"]]
      assert Parser.compare_lists(pattern_two, matched_two) == [["alex"], ["sam"]]
    end
  end
end
