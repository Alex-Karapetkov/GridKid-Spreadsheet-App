require_relative '../primitives/BooleanPrimitive'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class LogicalOr
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the or expression
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

    # evaluates the or expression
    def evaluate(environment)
        # evaluate operand expressions
        left = @first_operand.evaluate(environment)
        right = @second_operand.evaluate(environment)

        # perform typechecking
        if ((!left.boolean.is_a? TrueClass) && (!left.boolean.is_a? FalseClass))
            puts "Error: Evaluated operands are not Booleans."
            return
        end

        if ((!right.boolean.is_a? TrueClass) && (!right.boolean.is_a? FalseClass))
            puts "Error: Evaluated operands are not Booleans."
            return
        end

        disjunction = BooleanPrimitive.new(left.boolean || right.boolean, @start_index, @end_index)
    end

    # generate string representation of the or expression
    def to_s
        "(#{@first_operand.to_s} || #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

t = BooleanPrimitive.new(true)
f = BooleanPrimitive.new(false)

no = LogicalOr.new(f, f)
puts no
puts no.evaluate(environment)

yes = LogicalOr.new(f, t)
puts yes
puts yes.evaluate(environment)

yes = LogicalOr.new(t, t)
puts yes
puts yes.evaluate(environment)

# error
error = LogicalOr.new(false, f)
error = LogicalOr.new(f, true)

# another error
int = IntegerPrimitive.new(1)
error = LogicalOr.new(int, t)
=end

