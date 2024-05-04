# environment abstraction to hold executing program's runtime environment
# should also maintain a reference to the grid
# when an expression needs to look up a cell, it queries the environment
# which queries the grid in turn

# need to thread this environment through all recursive evaluate calls
require_relative 'Expression'
class Environment
    include Expression
    # create Environment abstraction
    def initialize(grid)
        @grid = grid
    end

    def get_cellValue(address)
        @grid.get_cell_value(address)
    end

    def calculate_maximum(top_left, bottom_right)
    end

    def calculate_minimum(top_left, bottom_right)
    end

    def calculate_mean(top_left, bottom_right)
    end

    def calculate_sum(top_left, bottom_right)
    end
end
