class Board
  attr_reader :cells
  def initialize()
    @cells = {}
    build_cells
  end
  
  def build_cells
    results = {}
    ("a".."d").each_with_index do |letter, num|
      coord = letter + num.to_s
      require "pry"; binding.pry
      results[coord] = Cell.new(coord) 
    end
  end
end