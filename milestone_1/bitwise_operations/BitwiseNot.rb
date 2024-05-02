require_relative '../primitives/BooleanPrimitive'
require_relative '../primitives/IntegerPrimitive'
require_relative '../Environment'
require_relative '../Grid'
require_relative '../Expression'

class BitwiseNot
    include Expression
    attr_accessor :start_index, :end_index
    # constructs an unevaluated form of the bitwise not expression
    def initialize(operand, start_index, end_index)
        if (!operand.is_a? Expression)
            puts "Error: #{operand} has illegal type."
            puts "  Must provide Expression type."
            return
        end

        @operand = operand
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the bitwise not expression
    def evaluate(environment)
        # evaluate operand expression
        evaluated = @operand.evaluate(environment)

        # perform typechecking
        if (!evaluated.is_a? Integer)
            puts "Error: Evaluated operand is not an Integer."
            return
        end

        flipped = IntegerPrimitive.new(~evaluated)
    end

    # generate string representation of the bitwise not expression
    def to_s
        "(~#{@operand.to_s}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = IntegerPrimitive.new(20)
b = IntegerPrimitive.new(5)

flipped = BitwiseNot.new(a)
puts flipped
puts flipped.evaluate(environment)

flipped = BitwiseNot.new(b)
puts flipped
puts flipped.evaluate(environment)

# error
a = 24
error = BitwiseNot.new(a)

# another error
boolean = BooleanPrimitive.new(false)
error = BitwiseNot.new(boolean)
=end