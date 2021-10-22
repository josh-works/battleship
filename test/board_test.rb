require './test/test_helper'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
  end
  
  def test_cells_returns_a_formatted_hash
    assert_instance_of Hash, @board.cells
    assert_equal "A1", @board.cells.first[0]
    assert_instance_of Cell, @board.cells.first[1]
    assert_equal 16, @board.cells.count
  end
  
  def valid_coordinate_returns_true_or_false
    assert @board.valid_coordinate?("A1")
    refute @board.valid_coordinate?("E1")
  end
  
end