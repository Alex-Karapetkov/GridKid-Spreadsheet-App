require_relative '../Expression'

class FloatPrimitive
    include Expression
    attr_accessor :start_index, :end_index

    # constructs unevaluated form of float
    def initialize(float, start_index, end_index)
        if (!float.is_a? Float)
            puts "Error: provided value #{float} is not a Float."
            return
        end
        @float = float
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the float primitive
    def evaluate(environment)
        @float
    end

    # generate string representation of float primitive
    def to_s
        "FloatPrimitive(#{@float}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
a = FloatPrimitive.new(5.0)
b = FloatPrimitive.new(3.0)
puts a.to_s
puts b.to_s

error = FloatPrimitive.new(3)
=end

