require_relative '../CellLvalue'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Mean
    include Expression
    # constructs an unevaluated form of the mean expression
    def initialize(top_left, bottom_right)
        if ((!top_left.is_a? CellLvalue) || (!bottom_right.is_a? CellLvalue))
            puts "Error: Provided cell values are not of the CellLvalue type."
            return
        end

        @top_left = top_left
        @bottom_right = bottom_right
    end

    # evaluates the mean expression
    def evaluate(environment)
        tleft = @top_left.evaluate(environment)
        bright = @bottom_right.evaluate(environment)

        mean_value = environment.calculate_mean(tleft, bright)
        FloatPrimitive.new(mean_value)
    end

    # generate string representation of the mean expression
    def to_s
        "Mean(#{@top_left.to_s}, #{@bottom_right.to_s})"
    end
end

grid = Grid.new(5,5)
environment = Environment.new(grid)

cell1 = CellLvalue.new(3,4)
cell2 = CellLvalue.new(8,8)

mean = Mean.new(cell1, cell2)
puts mean.to_s

# error
mean = Mean.new(2, cell1)
mean = Mean.new(cell1, 2.3)