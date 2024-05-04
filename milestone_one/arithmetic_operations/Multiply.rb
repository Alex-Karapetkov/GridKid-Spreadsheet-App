require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Expression'

class Multiply
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the multiply expression
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

    # evaluates the multiply expression
    def evaluate(environment)
        # evaluate operand expressions
        first_factor = @first_operand.evaluate(environment)
        second_factor = @second_operand.evaluate(environment)

        # perform typechecking
        if (!(first_factor.class == second_factor.class))
            puts "TypeError: operand types do not match."
            return
        end

        if (!first_factor.is_a? Numeric)
            puts "Error: Evaluated operands are not Numeric."
            return
        end

        product = first_factor * second_factor
    end

    # generate string representation of the multiply expression
    def to_s
        "(#{@first_operand.to_s} * #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(10)
b = IntegerPrimitive.new(5)
product = Multiply.new(a, b)
puts product
puts product.evaluate(environment)

c = FloatPrimitive.new(10.0)
d = FloatPrimitive.new(5.0)
product = Multiply.new(c, d)
puts product
puts product.evaluate(environment)

# error
a = 2
product = Multiply.new(a, b)

# TypeError
product = Multiply.new(IntegerPrimitive.new(9), FloatPrimitive.new(9.0)).evaluate(environment)

# TypeError
product = Multiply.new(FloatPrimitive.new(9.0), IntegerPrimitive.new(9)).evaluate(environment)
=end