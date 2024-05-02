require_relative '../CellLvalue'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Maximum
    include Expression
    # constructs an unevaluated form of the maximum expression
    def initialize(top_left, bottom_right)
        if ((!top_left.is_a? CellLvalue) || (!bottom_right.is_a? CellLvalue))
            puts "Error: Provided cell values are not of the CellLvalue type."
            return
        end

        @top_left = top_left
        @bottom_right = bottom_right
    end

    # evaluates the maximum expression
    def evaluate(environment)
        tleft = @top_left.evaluate(environment)
        bright = @bottom_right.evaluate(environment)

        max = environment.calculate_maximum(tleft, bright)
        IntegerPrimitive.new(max)
    end

    # generate string representation of maximum expression
    def to_s
        "Maximum(#{@top_left.to_s}, #{@bottom_right.to_s})"
    end
end

grid = Grid.new(5,5)
environment = Environment.new(grid)

cell1 = CellLvalue.new(3,3)
cell2 = CellLvalue.new(1,1)

max = Maximum.new(cell1, cell2)
puts max.to_s

# error
max = Maximum.new(3, 3)

