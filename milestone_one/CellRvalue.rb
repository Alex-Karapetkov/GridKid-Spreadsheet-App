# a cell reference whose value is what matters
require_relative 'Expression'
class CellRvalue
    include Expression
    attr_reader :row, :col

    # constructs unevaluated form of the cell rvalue
    def initialize(row, col)
        @row = row
        @col = col
    end

    # evaluates the cell rvalue
    def evaluate(environment)
        if ((!@row.is_a? Integer) || (!@col.is_a? Integer))
            puts "Error: Provided row and/or column is not an integer."
            return
        end
        environment.get_cellValue(self)
    end

    def to_s
        "Cell(#{@row}, #{@col})"
    end
end

=begin
a = CellRvalue.new(3, 9)
b = CellRvalue.new(9, 2)
puts a.row
puts a.col
puts a.to_s

puts b.row
puts b.col
puts b.to_s
=end

