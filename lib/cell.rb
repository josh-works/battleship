class Cell
  attr_reader :coordinate, :ship, :fired_upon
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end
  
  def empty?
    return false if ship
    true
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
  
  def render(debug_mode=false)
    return "S" if debug_mode && ship && cell_has_not_been_fired_upon?
    
    return "." if cell_has_not_been_fired_upon?
    return "M" if shot_was_a_miss?
    return "X" if ship_has_been_sunk?
    return "H" if shot_was_a_hit?
  end
  
  def ship_has_been_sunk?
    ship.sunk?
  end
  
  def shot_was_a_hit?
    fired_upon? && ship
  end
  
  def cell_has_not_been_fired_upon?
    !fired_upon?
  end
  
  def shot_was_a_miss?
    fired_upon? && empty?
  end
end