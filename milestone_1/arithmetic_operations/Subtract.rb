require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Subtract
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the subtract expression
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

    # evaluates the subtract expression
    def evaluate(environment)
        # evaluate operand expressions
        first_subtrahend = @first_operand.evaluate(environment)
        second_subtrahend = @second_operand.evaluate(environment)

        # perform typechecking
        if (!(first_subtrahend.class == second_subtrahend.class))
            puts "TypeError: operand types do not match."
            return
        end

        if (!first_subtrahend.is_a? Numeric)
            puts "Error: Evaluated operands are not Numeric."
            return
        end

        difference = first_subtrahend - second_subtrahend
    end

    # generate string representation of the subtract expression
    def to_s
        "(#{@first_operand.to_s} - #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(10)
b = IntegerPrimitive.new(5)
difference = Subtract.new(a, b)
puts difference
puts difference.evaluate(environment)

c = FloatPrimitive.new(10.0)
d = FloatPrimitive.new(5.0)
difference = Subtract.new(c, d)
puts difference
puts difference.evaluate(environment)

# error
a = 2.0
difference = Subtract.new(a, b)

# TypeError
difference = Subtract.new(IntegerPrimitive.new(8), FloatPrimitive.new(3.0)).evaluate(environment)

# TypeError
difference = Subtract.new(FloatPrimitive.new(15.0), IntegerPrimitive.new(5)).evaluate(environment)
=end