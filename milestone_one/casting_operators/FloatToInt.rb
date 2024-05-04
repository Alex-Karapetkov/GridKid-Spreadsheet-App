require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class FloatToInt
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the float-to-int expression
    def initialize(float, start_index, end_index)
        if (!float.is_a? FloatPrimitive)
            puts "Error: #{float} has illegal type."
            puts "  Must provide a FloatPrimitive type."
            return
        end

        @float = float
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the float-to-int expression
    def evaluate(environment)
        # evaluate operand expression
        value = @float.evaluate(environment)
        IntegerPrimitive.new(value.to_i)
    end

    # generate string representation of float-to-int expression
    def to_s
        "FloatToInt(#{@float.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

float = FloatPrimitive.new(3.0)
i = FloatToInt.new(float)
puts i
puts i.evaluate(environment)

# error
float = 3.3
i = FloatToInt.new(float)
=end
