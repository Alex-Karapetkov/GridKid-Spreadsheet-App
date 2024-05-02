require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class IntToFloat
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the int-to-float expression
    def initialize(int, start_index, end_index)
        if (!int.is_a? IntegerPrimitive)
            puts "Error: #{int} has illegal type."
            puts "  Must provide a IntegerPrimitive type."
            return
        end

        @int = int
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the int-to-float expression
    def evaluate(environment)
        # evaluate operand expression
        value = @int.evaluate(environment)
        FloatPrimitive.new(value.to_f)
    end

    # generate string representation of int-to-float expression
    def to_s
        "IntToFloat(#{@int.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

int = IntegerPrimitive.new(5)
f = IntToFloat.new(int)
puts f
puts f.evaluate(environment)

# error
int = 4
f = IntToFloat.new(int)
=end