require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/BooleanPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class RightShift
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the bitwise right shift expression
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

    # evaluates the bitwise right shift expression
    def evaluate(environment)
        # evaluate operand expressions
        numberToShift = @first_operand.evaluate(environment)
        bitsToShift = @second_operand.evaluate(environment)

        # perform typechecking
        if ((!numberToShift.is_a? Integer) && (!bitsToShift.is_a? Integer))
            puts "Error: Evaluated operands are not Integers."
            return
        end

        shifted = IntegerPrimitive.new(numberToShift >> bitsToShift)
    end

    # generate string representation of the bitwise right shift expression
    def to_s
        "(#{@first_operand.to_s} >> #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(21)
b = IntegerPrimitive.new(1)

rightShift = RightShift.new(a, b)
puts rightShift
puts rightShift.evaluate(environment)

# error
a = 1
error = RightShift.new(a, b)
error = RightShift.new(b, a)

# another error
boolean = BooleanPrimitive.new(false)
error = RightShift.new(boolean, b)
=end