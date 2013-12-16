require './cell'

# Square board
class Board
  attr_reader :cells

  def initialize(height = 15, width = 30)
    @width  = width
    @height = height

    generate_cells!
  end

  # Generate a board of cells.
  def generate_cells!
    @cells = Array.new(@height) do |i|
      Array.new(@width) do |j|
        Cell.new(i-1, j-1)
      end
    end
  end

  # Seed a random amount of cells to be alive.
  def seed!
    Random.rand(@width * @height).times do
      row = @cells.sample
      cell = row.sample
      cell.its_alive!
    end
  end

  # Sets cells to alive for the given coordinates.
  def set_to_alive(coordinates = [])
    coordinates.each do |x, y|
      cell(x, y).its_alive!
    end
  end

  # Generates a new board with cells that should be alive.
  def generate_new
    board = self.class.new(@height, @width)
    board.set_to_alive(coordinates_for_new_cells)
    board
  end

  # Returns an array of coordinates for cells that should be 
  # alive after the current tick.
  def coordinates_for_new_cells
    coordinates = []

    @cells.flatten.each do |cell|
      count = neighbor_count_for_cell(cell)
      if cell.alive?
        if count == 2 || count == 3
          coordinates << [cell.x, cell.y]
        end
      else
        if count == 3
          coordinates << [cell.x, cell.y]
        end
      end
    end

    coordinates
  end

  # Count the number of neighbors for a cell.
  def neighbor_count_for_cell(cell)
    count = 0

    ((cell.x - 1)..(cell.x + 1)).each do |i|
      ((cell.y - 1)..(cell.y + 1)).each do |j|
        if cell(i, j).alive?
          count += 1
        end
      end
    end

    count
  end

  # Grabs a cell for given coordinates.
  def cell(x, y)
    @cells[x][y]
  end

  # Print the board.
  def print
    system("clear")
    @cells.each do |row|
      putc "|"
      putc " "
      row.each do |cell|
        putc cell.to_s
        putc " "
      end
      putc "|"
      putc "\n"
    end
    puts
  end
end