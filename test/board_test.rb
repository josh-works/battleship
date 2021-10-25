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
  
  def test_valid_placement_returns_true_for_valid_placement
    cruiser = Ship.new("Cruiser", 3)
    
    # valid horizontal placement
    assert @board.valid_placement?(cruiser, ["A1", "A2", "A3"])
    
    # valid vertical placement
    assert @board.valid_placement?(cruiser, ["A1", "B1", "C1"])
  end
  
  def test_diagonal_placement_returns_true_if_any_placements_are_diagonal
    assert @board.any_diagonal_placements?(["A1", "B2"])
    refute @board.any_diagonal_placements?(["A1", "B1"])
    refute @board.any_diagonal_placements?(["A1", "A1"])
    assert @board.any_diagonal_placements?(["A1", "A2", "B3"])
    assert @board.any_diagonal_placements?(["A1", "B1", "C2"])
  end
  
  def test_valid_placement_returns_false_for_invalid_placement
    cruiser = Ship.new("Cruiser", 3)
    
    # wrong length.... # done
    refute @board.valid_placement?(cruiser, ["A1", "A2"])
    
    # diagonal placement... # done
    refute @board.valid_placement?(cruiser, ["A1", "B3", "B4"])
    
    # outside the bounds of the board vertially ... # TODO
    refute @board.valid_placement?(cruiser, ["C1", "D1", "E1"])
    
    # outside the bounds of the board horizontally ... # TODO
    refute @board.valid_placement?(cruiser, ["C3", "C4", "C5"])
  end  
  
  def test_place_places_ship_in_cells
    cruiser = Ship.new(cruiser, 3)
    @board.place(cruiser, ["A1", "A2", "A3"])
    
    assert_equal cruiser, @board.cells["A1"].ship
    assert_equal cruiser, @board.cells["A2"].ship
    assert_equal cruiser, @board.cells["A3"].ship
    refute @board.cells["A4"].ship
  end
  
  def test_coords_overlap_with_existing_ship_returns_false_if_overlapping_ship
    cruiser = Ship.new("Cruiser", 3)
    
    @board.place(cruiser, ["A1", "A2", "A3"])

    assert @board.coords_overlap_with_existing_ship?(["A1", "B1", "C1", "D1"])
  end
  
  def test_valid_placement_returns_false_if_overlapping_ships
    cruiser = Ship.new("Cruiser", 3)
    sub = Ship.new("Submarine", 4)
    
    @board.place(cruiser, ["A1", "A2", "A3"])
    
    refute @board.valid_placement?(sub, ["A1", "B1", "C1", "D1"])
  end
  
  def test_render_renders_nicely_formatted_board
    expected =  "  1 2 3 4 \n" +
                "A . . . . \n" +
                "B . . . . \n" +
                "C . . . . \n" +
                "D . . . . \n"
    puts build_board_hash
    assert_equal expected, @board.render
  end
end
