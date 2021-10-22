require './test/test_helper'

class BoardTest < Minitest::Test
  def setup
    @board = Board.new
  end
  
  def test_cells_returns_a_formatted_hash
    assert_instance_of Hash, @board.cells
    assert_equal "A1", @board.cells.first[0]
    assert_instance_of Cell, @board.cells.first[1]
  end
  
end