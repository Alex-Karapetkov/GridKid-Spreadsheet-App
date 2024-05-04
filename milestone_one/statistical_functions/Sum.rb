require_relative '../CellLvalue'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Sum
    include Expression
    # constructs an unevaluated form of the sum expression
    def initialize(top_left, bottom_right)
        if ((!top_left.is_a? CellLvalue) || (!bottom_right.is_a? CellLvalue))
            puts "Error: Provided cell values are not of the CellLvalue type."
            return
        end

        @top_left = top_left
        @bottom_right = bottom_right
    end

    # evaluates the sum expression
    def evaluate(environment)
        tleft = @top_left.evaluate(environment)
        bright = @bottom_right.evaluate(environment)

        sum_value = environment.calculate_sum(tleft, bright)
        IntegerPrimitive.new(sum_value)
    end

    # generates string representation of the sum expression
    def to_s
        "Sum(#{@top_left.to_s}, #{@bottom_right.to_s})"
    end
end

grid = Grid.new(5,5)
environment = Environment.new(grid)

cell1 = CellLvalue.new(2,3)
cell2 = CellLvalue.new(6,5)

sum = Sum.new(cell1, cell2)
puts sum.to_s

# error
sum = Sum.new(2.2, cell1)
sum = Sum.new(cell2, 1)