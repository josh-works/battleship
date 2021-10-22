class Board
  attr_reader :cells
  def initialize()
    @cells = build_cells
  end
  
  def build_cells
    ("a".."d").each_with_index do |letter, num|
      coord = letter + num.to_s
      @cells[coord] = Cell.new(cord)
    end
  end
end