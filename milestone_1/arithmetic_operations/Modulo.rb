require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Modulo
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the modulo expression
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

    # evaluates the modulo expression
    def evaluate(environment)
        # evaluate operand expressions
        dividend = @first_operand.evaluate(environment)
        divisor = @second_operand.evaluate(environment)

        # perform typechecking
        if (!(dividend.class == divisor.class))
            puts "TypeError: operand types do not match."
            return
        end

        if (!dividend.is_a? Numeric)
            puts "Error: Evaluated operands are not Numeric."
            return
        end

        remainder = dividend % divisor
    end

    # generate string representation of the modulo expression
    def to_s
        "(#{@first_operand.to_s} % #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(5)
b = IntegerPrimitive.new(3)
remainder = Modulo.new(a, b)
puts remainder
puts remainder.evaluate(environment)

c = FloatPrimitive.new(5.0)
d = FloatPrimitive.new(3.0)
remainder = Modulo.new(c, d)
puts remainder
puts remainder.evaluate(environment)

# error
a = 1
remainder = Modulo.new(a, b)

# TypeError
remainder = Modulo.new(IntegerPrimitive.new(8), FloatPrimitive.new(1.0)).evaluate(environment)

# TypeError
remainder = Modulo.new(FloatPrimitive.new(1.0), IntegerPrimitive.new(3)).evaluate(environment)
=end