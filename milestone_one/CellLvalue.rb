# a cell reference whose address is what matters
require_relative 'Expression'
class CellLvalue
    include Expression
    attr_reader :row, :col

    # constructs unevaluated form of a cell lvalue
    def initialize(row, col)
        @row = row
        @col = col
    end

    # evaluates the cell lvalue
    def evaluate(environment)
        if ((!@row.is_a? Integer) || (!@col.is_a? Integer))
            puts "Error: Provided row and/or column is not an integer."
            return
        end
        self
    end

    def to_s
        "Cell(#{@row}, #{@col})"
    end
end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)

a = CellLvalue.new(3,3)
b = CellLvalue.new(1,4)
puts a.row
puts a.col
puts a.to_s

puts b.row
puts b.col
puts b.to_s

# error
a = CellLvalue.new(3.0, 2)
b = CellLvalue.new(2, 3.0)
puts a.evaluate(environment)
puts b.evaluate(environment)
=end