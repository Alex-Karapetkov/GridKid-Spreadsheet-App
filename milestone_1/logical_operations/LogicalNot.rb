require_relative '../primitives/BooleanPrimitive'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class LogicalNot
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the not expression
    def initialize(operand, start_index, end_index)
        if (!operand.is_a? BooleanPrimitive)
            puts "Error: #{operand} has illegal type."
            puts "  Must provide BooleanPrimitive type."
            return
        end

        @operand = operand
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the not expression
    def evaluate(envrionment)
        # evaluate operand expressions
        evaluated = @operand.evaluate(envrionment)

        # perform typechecking
        if ((!evaluated.boolean.is_a? TrueClass) && (!evaluated.boolean.is_a? FalseClass))
            puts "Error: Evaluated operand is not a Boolean."
            return
        end

        result = BooleanPrimitive.new(!(evaluated.boolean), @start_index, @end_index)
    end

    # generate string representation of the not expression
    def to_s
        "(!#{@operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

t = BooleanPrimitive.new(true)
f = BooleanPrimitive.new(false)

no = LogicalNot.new(t)
puts no
puts no.evaluate(environment)

yes = LogicalNot.new(f)
puts yes
puts yes.evaluate(environment)

# error
error = LogicalNot.new(false)

# another error
int = IntegerPrimitive.new(1)
error = LogicalNot.new(int)

=end