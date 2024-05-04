require_relative 'CellLvalue'
require_relative 'CellRvalue'
require_relative 'primitives/IntegerPrimitive'
require_relative 'Expression'
require_relative 'arithmetic_operations/Add'
require_relative 'arithmetic_operations/Multiply'


#require_relative 'arithmetic_operations/Add'
#require_relative 'arithmetic_operations/Multiply'

# grid abstaction that holds the spreadsheet's scattered expressions
# should have following operations:
    # a setter that accepts an address and an arbitrary expression
    # a getter that accepts an address and returns the cell's evaluated primitive value

class Grid
    include Expression

    def initialize(num_rows, num_columns)
        @num_rows = num_rows
        @num_columns = num_columns
        @grid_contents = Array.new(num_rows) { Array.new(num_columns, 0) }
    end

    def set_cell_expression(address, expression)
        if (address.row >= @num_rows || address.row < 0)
            raise StandardError, "Row of provided address does not exist."
        end

        if (address.col >= @num_columns || address.col < 0)
            raise StandardError, "Column of provided address does not exist."
        end

        @grid_contents[address.row][address.col] = expression
    end

    def get_cell_value(address)
        if (address.row >= @num_rows || address.row < 0)
            raise StandardError, "Row of provided address does not exist."
        end

        if (address.col >= @num_columns || address.col < 0)
            raise StandardError, "Column of provided address does not exist."
        end

        expression = @grid_contents[address.row][address.col]

        if (expression.nil? || expression == 0)
            raise StandardError, "Cell is empty."
        end
        
        expression.evaluate(Environment.new(self))
    end
end

=begin
grid = Grid.new(5,5)
address_one = CellLvalue.new(0,0)
expression_one = Add.new(IntegerPrimitive.new(5), IntegerPrimitive.new(5))
grid.set_cell_expression(address_one, expression_one)

address_two = CellLvalue.new(3,2)
expression_two = Add.new(IntegerPrimitive.new(1), IntegerPrimitive.new(1))
grid.set_cell_expression(address_two, expression_two)

# evaluate expressions
puts grid.get_cell_value(address_one)
puts grid.get_cell_value(address_two)


# error
grid.set_cell_expression(CellLvalue.new(-10,10), expression_one)

empty_address = CellLvalue.new(0,1)
grid.get_cell_value(empty_address)
=end

=begin
grid = Grid.new(5,5)
environment = Environment.new(grid)
a1 = CellRvalue.new(1,1)
a2 = CellRvalue.new(1,2)
a3 = CellRvalue.new(1,3)

expression1 = Add.new(IntegerPrimitive.new(1), IntegerPrimitive.new(2))
expression2 = Multiply.new(IntegerPrimitive.new(3), IntegerPrimitive.new(3))

grid.set_cell_expression(a1, expression1)
grid.set_cell_expression(a2, expression2)

expression3 = Add.new(a1, a2)
grid.set_cell_expression(a3, expression3)
puts grid.get_cell_value(a3)
=end
    
