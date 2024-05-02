require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/BooleanPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class BitwiseXOr
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the bitwise xor expression
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

    # evaluates the bitwise xor expression
    def evaluate(environment)
        # evaluate operand expressions
        left = @first_operand.evaluate(environment)
        right = @second_operand.evaluate(environment)

        # perform typechecking
        if ((!left.is_a? Integer) && (!right.is_a? Integer))
            puts "Error: Evaluated operands are not Integers."
            return
        end

        result = IntegerPrimitive.new(left ^ right)
    end

    # generate string representation of the bitwise xor expression
    def to_s
        "(#{@first_operand.to_s} ^ #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(10)
b = IntegerPrimitive.new(2)

sum = BitwiseXOr.new(a, b)
puts sum
puts sum.evaluate(environment)

# error
a = 5
error = BitwiseXOr.new(a, b)
error = BitwiseXOr.new(b, a)

# another error
boolean = BooleanPrimitive.new(true)
error = BitwiseXOr.new(boolean, b)
=end