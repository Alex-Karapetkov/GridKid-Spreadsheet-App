require_relative '../primitives/BooleanPrimitive'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class LogicalAnd
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the and expression
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

    # evaluates the and expression
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

        conjunction = BooleanPrimitive.new(left.boolean && right.boolean, @start_index, @end_index)
    end

    # generate string representation of the and expression
    def to_s
        "(#{@first_operand.to_s} && #{@second_operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

t = BooleanPrimitive.new(true)
f = BooleanPrimitive.new(false)

no = LogicalAnd.new(t, f)
puts no
puts no.evaluate(environment)

yes = LogicalAnd.new(t, t)
puts yes
puts yes.evaluate(environment)

# error
error = LogicalAnd.new(true, f)
error = LogicalAnd.new(f, true)

# another error
int = IntegerPrimitive.new(5)
error = LogicalAnd.new(int, t)

=end


