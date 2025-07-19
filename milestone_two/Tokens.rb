# model token class for all tokens to extend
class Token
    attr_accessor :type, :text, :start_index, :end_index

    def initialize(type, text, start_index, end_index)
        @type = type
        @text = text
        @start_index = start_index
        @end_index = end_index
    end

    def to_s
        "type: #{@type}, text: #{@text}, start: #{@start_index}, end: #{@end_index}"
    end
end
