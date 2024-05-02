require_relative '../primitives/IntegerPrimitive'
require_relative '../primitives/FloatPrimitive'
require_relative '../primitives/BooleanPrimitive'
require_relative '../primitives/StringPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class Equals
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the relational equals expression
    def initialize(first_operand, second_operand, start_index, end_index)
        if ((!first_operand.is_a? IntegerPrimitive) && (!first_operand.is_a? FloatPrimitive) &&
            (!first_operand.is_a? BooleanPrimitive) && (!first_operand.is_a? StringPrimitive))
            puts "Error: #{first_operand} has illegal type."
            puts "  Must provide either IntegerPrimitive, FloatPrimitive, StringPrimitive,
            or BooleanPrimitive type."
            return
        end

        if ((!second_operand.is_a? IntegerPrimitive) && (!second_operand.is_a? FloatPrimitive) &&
            (!second_operand.is_a? BooleanPrimitive) && (!second_operand.is_a? StringPrimitive))
            puts "Error: #{second_operand} has illegal type."
            puts "  Must provide either IntegerPrimitive, FloatPrimitive, StringPrimitive,
            or BooleanPrimitive type."
            return
        end

        @first_operand = first_operand
        @second_operand = second_operand
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the relational equals expression
    def evaluate(environment)
        # evaluate operand expressions
        left = @first_operand.evaluate(environment)
        right = @second_operand.evaluate(environment)

        # perform typechecking
        if (!(@first_operand.class == @second_operand.class))
            puts "TypeError: operand types do not match."
            return
        end

        result = BooleanPrimitive.new(left == right, @start_index, @end_index)
    end

    # generate string representation of the relational equals expression
    def to_s
        "(#{@first_operand.to_s} == #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

intOne = IntegerPrimitive.new(5)
intTwo = IntegerPrimitive.new(3)

floatOne = FloatPrimitive.new(3.0)
floatTwo = FloatPrimitive.new(2.0)

t = BooleanPrimitive.new(true)
f = BooleanPrimitive.new(false)

stringOne = StringPrimitive.new("hello")
stringTwo = StringPrimitive.new("Hello")

compare = Equals.new(intOne, intTwo)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(intOne, intOne)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(floatOne, floatTwo)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(floatTwo, floatTwo)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(t, f)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(f, f)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(stringOne, stringTwo)
puts compare
puts compare.evaluate(environment)

compare = Equals.new(stringTwo, stringTwo)
puts compare
puts compare.evaluate(environment)

# error
error = "hi"
compare = Equals.new(stringOne, error)

# TypeError
compare = Equals.new(intOne, stringTwo)
puts compare
puts compare.evaluate(environment)

=end