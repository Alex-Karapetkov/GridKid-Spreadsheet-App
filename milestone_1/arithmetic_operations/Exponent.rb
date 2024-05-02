require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Exponent
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the exponent expression
    def initialize(first_operand, second_operand, start_index, end_index)
        if (!first_operand.is_a? Expression)
            puts "Error: #{first_operand} has illegal type."
            puts "  Must provide Expression type."
            return
        end

        if (!second_operand.is_a? Expression)
            puts "Error: #{second_operand} has illegal type."
            puts "  Must provide Expression type."
            return
        end

        @first_operand = first_operand
        @second_operand = second_operand
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the exponent expression
    def evaluate(environment)
        # evaluate operand expressions
        base = @first_operand.evaluate(environment)
        exponent = @second_operand.evaluate(environment)

        # perform typechecking
        if (!(base.class == exponent.class))
            puts "TypeError: operand types do not match."
            return
        end

        if (!base.is_a? Numeric)
            puts "Error: Evaluated operands are not Numeric."
            return
        end

        result = base ** exponent
    end

    # generate string representation of the exponent expression
    def to_s
        "(#{@first_operand.to_s} ** #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(5)
b = IntegerPrimitive.new(2)
result = Exponent.new(a, b)
puts result
puts result.evaluate(environment)

c = FloatPrimitive.new(7.0)
d = FloatPrimitive.new(2.0)
result = Exponent.new(c, d)
puts result
puts result.evaluate(environment)

# error
a = 3.5
result = Exponent.new(a, b)

# TypeError
result = Exponent.new(IntegerPrimitive.new(8), FloatPrimitive.new(6.0)).evaluate(environment)

# TypeError
result = Exponent.new(FloatPrimitive.new(2.4), IntegerPrimitive.new(4)).evaluate(environment)
=end