class Board
  attr_reader :cells, :width
  def initialize(width = 4)
    @cells = {}
    @width = width
    build_cells
  end
  
  def build_cells
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
    return false if coords_overlap_with_existing_ship?(coords)
    true
  end
  
  def coords_overlap_with_existing_ship?(coords)
    coords.any? do |coord|
      !cells[coord].empty?
    end
  end
  
  def place(ship, coords)
    return false unless valid_placement?(ship, coords)
    
    coords.each do |coord|  
      cells[coord].place_ship(ship)
    end
  end
  
  
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
  
  def render
    output = ""
    top_row = "  "
    width.times { |i| top_row += "#{i + 1} " }
    top_row += "\n"
    
    output += top_row
    
    board_hash = build_board_hash
    board_hash.each do |k, v|
      output += "#{k} #{v}\n"
    end
    output
  end
  
  private
  
    def build_board_hash 
      cells.reduce({}) do |acc, coord_array|
        row = coord_array[0].chars.first
        cell = coord_array[1]
        
        acc[row] ||= ""
        acc[cell.coordinate.chars.first] += "#{cell.render} "
        acc
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