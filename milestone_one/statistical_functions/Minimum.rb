require_relative '../CellLvalue'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Minimum
    include Expression
    # constructs an unevaluated form of the minimum expression
    def initialize(top_left, bottom_right)
        if ((!top_left.is_a? CellLvalue) || (!bottom_right.is_a? CellLvalue))
            puts "Error: Provided cell values are not of the CellLvalue type."
            return
        end

        @top_left = top_left
        @bottom_right = bottom_right
    end

    # evaluates the minimum expression
    def evaluate(environment)
        tleft = @top_left.evaluate(environment)
        bright = @bottom_right.evaluate(environment)

        min = environment.calculate_minimum(tleft, bright)
        IntegerPrimitive.new(min)
    end

    # generate string representation of minimum expression
    def to_s
        "Minimum(#{@top_left.to_s}, #{@bottom_right.to_s})"
    end
end

grid = Grid.new(5,5)
environment = Environment.new(grid)

cell1 = CellLvalue.new(1,2)
cell2 = CellLvalue.new(5,5)

min = Minimum.new(cell1, cell2)
puts min.to_s

# error
min = Minimum.new(3, cell2)
min = Minimum.new(cell2, 3)