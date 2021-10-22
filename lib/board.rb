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
end