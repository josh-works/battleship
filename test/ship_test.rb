require './test/test_helper'

class ShipTest < Minitest::Test
  def setup
    @ship = Ship.new("cruiser", 3)
  end
  
  def test_attributes
    assert_equal "cruiser", @ship.name
    assert_equal 3, @ship.length
    assert_equal 3, @ship.health
    refute @ship.sunk?
  end
  
  def test_ship_can_be_hit_and_sunk
    @ship.hit
    assert_equal 2, @ship.health
    refute @ship.sunk?
    
    @ship.hit
    @ship.hit
    
    assert_equal 0, @ship.health
    assert @ship.sunk?
  end
end