require_relative "../Expression"
class StringPrimitive
    include Expression
    attr_accessor :start_index, :end_index
    # constructs unevaluated form of string
    def initialize(string, start_index, end_index)
        if (!string.is_a? String)
            puts "Error: provided value is not a String."
            return
        end
        @string = string
        @start_index = start_index
        @end_index = end_index
    end

    # evaluates the string primitive
    def evaluate(environment)
        @string
    end

    # generate string representation of string primitive
    def to_s
        "StringPrimitive(#{@string}, (#{@start_index}, #{@end_index}))"
    end
end

=begin
hello = StringPrimitive.new("hello")
goodbye = StringPrimitive.new("goodbye")
puts hello.to_s
puts goodbye.to_s

error = StringPrimitive.new(5)
another_error = StringPrimitive.new(hello)
=end