class Cell
  attr_reader :coordinate, :ship, :fired_upon
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end
  
  def empty?
    true unless ship
  end
  
  def place_ship(ship)
    @ship = ship
  end
  
  def fired_upon?
    fired_upon
  end
  
  def fire_upon
    @fired_upon = true
    ship.hit if ship
  end
  
  def render
    return "." if cell_has_not_been_fired_upon?
    return "M" if fired_upon_and_empty?
    return "X" if ship_has_been_sunk?
    return "H" if fired_upon_and_contains_ship?
  end
  
  def ship_has_been_sunk?
    ship.sunk?
  end
  
  def fired_upon_and_contains_ship?
    fired_upon? && ship
  end
  
  def cell_has_not_been_fired_upon?
    !fired_upon?
  end
  
  def fired_upon_and_empty?
    fired_upon? && empty?
  end
end