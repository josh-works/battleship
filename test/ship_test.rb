require './test/test_helper'

class ShipTest < Minitest::Test
  def setup
    @ship = Ship.new("cruiser", 3)
  end
  
  def test_attributes
    assert_equal "cruiser", @ship.name
    assert_equal 3, @ship.length
    assert_equal 3, @ship.health
    # refute ship.sunk
  end
end