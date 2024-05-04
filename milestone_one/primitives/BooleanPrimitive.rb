require_relative "../Expression"
class BooleanPrimitive
    include Expression
    attr_accessor :start_index, :end_index, :boolean
    # constructs unevaluated form of boolean
    def initialize(boolean, start_index, end_index)
        if ((!boolean.is_a? TrueClass) && (!boolean.is_a? FalseClass))
            puts "Error: provided value is not a Boolean."
            return
        end
        @boolean = boolean
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the boolean primitive
    def evaluate(environment)
        @boolean
    end

    # generate string representation of boolean primitive
    def to_s
        "BooleanPrimitive(#{@boolean}, (#{@start_index}, #{end_index}))"
    end
end

=begin
a = BooleanPrimitive.new(true)
b = BooleanPrimitive.new(false)
puts a.to_s
puts b.to_s

error = BooleanPrimitive.new(3.0)
another_error = BooleanPrimitive.new("word")
=end
