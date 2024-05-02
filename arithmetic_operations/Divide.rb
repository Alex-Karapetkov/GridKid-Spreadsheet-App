require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'


class Divide
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the divide expression
    def initialize(first_operand, second_operand, start_index, end_index)
        if (!first_operand.is_a? Expression)
            puts "Error: #{first_operand} has illegal type."
            puts "  Must provide Expression type."
            return
        end

        if (!second_operand.is_a? Expression)
            puts "Error: #{second_operand} has illegal type."
            puts "  Must Expression type."
            return
        end

        @first_operand = first_operand
        @second_operand = second_operand
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the divide expression
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

        quotient = dividend / divisor
    end

    # generate string representation of the divide expression
    def to_s
        "(#{@first_operand.to_s} / #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(10)
b = IntegerPrimitive.new(5)
quotient = Divide.new(a, b)
puts quotient
puts quotient.evaluate(environment)

c = FloatPrimitive.new(20.0)
d = FloatPrimitive.new(5.0)
quotient = Divide.new(c, d)
puts quotient
puts quotient.evaluate(environment)

# error
a = 1.0
quotient = Divide.new(a, b)

# TypeError
quotient = Divide.new(IntegerPrimitive.new(9), FloatPrimitive.new(1.2)).evaluate(environment)

# TypeError
quotient = Divide.new(FloatPrimitive.new(1.3), IntegerPrimitive.new(9)).evaluate(environment)
=end