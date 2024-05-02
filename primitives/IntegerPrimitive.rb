require_relative "../Expression"
class IntegerPrimitive
    include Expression
    attr_accessor :start_index, :end_index

    # constructs unevaluated form of integer
    def initialize(integer, start_index, end_index)
        if (!integer.is_a? Integer)
            puts "Error: provided value #{integer} is not an Integer."
            return
        end
        @integer = integer
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the integer primitive
    def evaluate(environment)
        @integer
    end

    # generate string representation of integer primitive
    def to_s
        "IntegerPrimitive(#{@integer}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
a = IntegerPrimitive.new(5)
b = IntegerPrimitive.new(3)
puts a.to_s
puts b.to_s

error = IntegerPrimitive.new(3.0)
=end



