require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../Environment'
require_relative '../Expression'


class Add
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the add expression
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

    # evaluates the add expression
    def evaluate(environment)
        # evaluate operand expressions
        first_addend = @first_operand.evaluate(environment)
        second_addend = @second_operand.evaluate(environment)
        
        # perform typechecking
        if (!(first_addend.class == second_addend.class))
            puts "TypeError: operand types do not match."
            return
        end

        if (!first_addend.is_a? Numeric)
            puts "Error: Evaluated operands are not Numeric."
            return
        end

        sum = first_addend + second_addend
    end

    # generate string representation of the add expression
    def to_s
        "(#{@first_operand.to_s} + #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(5)
b = IntegerPrimitive.new(3)
sum = Add.new(a, b)
puts sum
puts sum.evaluate(environment)

c = FloatPrimitive.new(5.0)
d = FloatPrimitive.new(3.0)
sum = Add.new(c, d)
puts sum
puts sum.evaluate(environment)

# error
a = 5
sum = Add.new(a, b)

# TypeError
sum = Add.new(IntegerPrimitive.new(8), FloatPrimitive.new(5.0)).evaluate(environment)

# TypeError
sum = Add.new(FloatPrimitive.new(5.0), IntegerPrimitive.new(8)).evaluate(environment)
=end
