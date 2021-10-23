class Board
  attr_reader :cells
  def initialize()
    @cells = {}
    build_cells
  end
  
  def build_cells
    width = 4
    ("a".."d").each do |letter|
      width.times do |num|  
        coord = letter.upcase + (num + 1).to_s
        @cells[coord] = Cell.new(coord) 
      end
    end
  end
  
  def valid_coordinate?(coord)
    @cells[coord]
  end
  
  def valid_placement?(ship, coords)
    return false if invalid_ship_length?(ship, coords)
    return false if any_diagonal_placements?(coords)
    return false if !all_cords_inside_board?(coords)
    true
  end
  
  private
    
    def any_diagonal_placements?(coords)
      contains_diagonal_placement = false
      
      coords.each_with_index do |coord, i|
        return contains_diagonal_placement if coords[i+1].nil?
        
        # check if row is same, `next` if so
        row_1 = coord.chars.first
        row_2 = coords[i+1].chars.first
        next if row_1 == row_2
        
        if row_1 != row_2
          col_1 = coord.chars.last
          col_2 = coords[i+1].chars.last
          contains_diagonal_placement = true if col_1 != col_2
        end
      end
    end
    
    
    def invalid_ship_length?(ship, coords)
      ship.length != coords.length
    end
    
    def all_cords_inside_board?(coords)
      coords.all? do |coord|
        valid_coordinate?(coord)
      end
    end
end