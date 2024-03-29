require './test/test_helper'

class CellTest < Minitest::Test
  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end
  
  def test_basic_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
    assert @cell.empty?
  end
  
  def test_place_ship_places_ship
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
    refute @cell.empty?
  end
  
  def test_cell_can_be_fired_upon_and_know_about_it
    @cell.place_ship(@cruiser)
    
    refute @cell.fired_upon?
    
    @cell.fire_upon
    
    assert @cell.fired_upon?
    assert_equal 2, @cruiser.health
  end
  
  def test_render_returns_period_if_not_fired_upon
    # . if the cell has not been fired upon.
    assert_equal ".", @cell.render
  end
  
  def test_render_returns_M_if_shot_was_a_miss
    empty_cell = Cell.new("B5")
    empty_cell.fire_upon
    # M if the cell has been fired upon and it does not contain a ship (the shot was a miss).
    assert empty_cell.empty?
    assert_equal "M", empty_cell.render
  end
  
  def test_render_returns_H_if_shot_was_a_hit
    # H if the cell has been fired upon and it contains a ship (the shot was a hit).
    @cell.place_ship(@cruiser)     # place the ship
    @cell.fire_upon                # fire upon placed ship
    
    assert_equal "H", @cell.render # assert that ship shows it's been hit
  end
  
  def test_render_returns_X_if_ship_is_sunk
    @cell.place_ship(@cruiser)     # place the ship
    @cell.fire_upon                # fire upon ship
    @cruiser.hit                   # hit ship 2x more
    @cruiser.hit
    
    assert @cruiser.sunk?
    # X if the cell has been fired upon and its ship has been sunk.
    assert_equal "X", @cell.render
  end
  
  def test_render_in_debug_mode_reveals_ship_location
    @cell.place_ship(@cruiser)
    empty_cell = Cell.new("C2")
    
    assert_equal ".", @cell.render
    
    assert_equal "S", @cell.render(true)
    assert_equal ".", empty_cell.render(true)
  end
end