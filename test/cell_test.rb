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
end