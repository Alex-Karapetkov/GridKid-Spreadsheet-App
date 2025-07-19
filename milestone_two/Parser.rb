=begin
define a parser that accepts a list of tokens and assembles an abstract syntax tree using
the model abstractions you write in milestone 1; for example, parsing the expression
5 <= 32.0 yields this pseudocode structure:
    new LessThanOrEqual(
        new IntegerLiteral(5, (0, 0)),
        new FloatLiteral(32.0, (5, 8)),
        (0, 8)
    )

Note that the model abstractions should now accept an additional location parameter; you'll
need to store these locations in the expression nodes so that you can generate error messages
on when the tree is evaluated; your parser should have these helper methods:
    - parse to parse the complete list of tokens and return an AST
    - has to see if the next token has a certain type
    - capture to move forward in the tokens list

you should also have a method for each non-terminal in your grammar; the parsing should start
at expression and works its way down through all precedence levels to atom; as you implement
these methods, model the sequences and alternatives of the productions with conditional statements
, loops, and calls to other non-terminal methods

Each non-terminal method should return an instance of one of your model abstractions; after all the
tokens have been gobbled up by your non-terminal methods, the final value returned by parse is the root
of an abstract syntax tree

Implementation should detect and gracefully handle errors in the programmer's source code; if you encounter
an unexpected token or run out of tokens early, throw an exception with an explanatory message and the location
in the source code where the error occured

Write tests that lex and parse the source code for a variety of expressions, evaluate the ASTs, and assert
that they produce the expected primitive values; ensure that your parser doesn't overstep its bounds; it doesn't
try to perform any type checking or evaluate any expressions
=end

require_relative '../milestone_one/logical_operations/LogicalOr'
require_relative '../milestone_one/logical_operations/LogicalAnd'
require_relative '../milestone_one/logical_operations/LogicalNot'
require_relative '../milestone_one/relational_operations/Equals'
require_relative '../milestone_one/relational_operations/NotEquals'
require_relative '../milestone_one/relational_operations/GreaterThan'
require_relative '../milestone_one/relational_operations/GreaterOrEqual'
require_relative '../milestone_one/relational_operations/LessThan'
require_relative '../milestone_one/relational_operations/LessOrEqual'
require_relative '../milestone_one/bitwise_operations/BitwiseAnd'
require_relative '../milestone_one/bitwise_operations/BitwiseOr'
require_relative '../milestone_one/bitwise_operations/BitwiseXOr'
require_relative '../milestone_one/bitwise_operations/LeftShift'
require_relative '../milestone_one/bitwise_operations/RightShift'
require_relative '../milestone_one/arithmetic_operations/Add'
require_relative '../milestone_one/arithmetic_operations/Subtract'
require_relative '../milestone_one/arithmetic_operations/Multiply'
require_relative '../milestone_one/arithmetic_operations/Divide'
require_relative '../milestone_one/arithmetic_operations/Modulo'
require_relative '../milestone_one/arithmetic_operations/Exponent'
require_relative '../milestone_one/casting_operators/FloatToInt'
require_relative '../milestone_one/casting_operators/IntToFloat'
require_relative '../milestone_one/bitwise_operations/BitwiseNot'
require_relative '../milestone_one/primitives/BooleanPrimitive'
require_relative '../milestone_one/primitives/FloatPrimitive'
require_relative '../milestone_one/primitives/IntegerPrimitive'
require_relative '../milestone_one/primitives/StringPrimitive'

require_relative 'Lexer'
require_relative 'Tokens'
require_relative '../milestone_one/Grid'
require_relative '../milestone_one/Environment'


class Parser
    attr_accessor :tokens, :current_token, :index
    def initialize(tokens)
        @tokens = tokens
        @current_token = @tokens[0]
        @index = 0
    end

    # ---helper methods---

    # parse should parse the complete list of tokens and return an AST
    # have parse start at top of grammar, at highest non-terminal (lowest precedence level)
    def parse
        parse_expression
    end

    # has should see if the next token has a certain type
    def has(expected_type)
        if (@current_token != nil)
            @current_token.type == expected_type
        end
    end

    # capture should move forward in the tokens list
    def capture
        token = @current_token
        @index += 1
        @current_token = @tokens[@index]
        token
    end

    # --- non-terminal methods ---
    def parse_expression
        parse_logical_or
    end

    def parse_logical_or
            left = parse_logical_and
            # while current token is of type LOG_OR
            while has('LOG_OR')
                # capture operator
                token = capture
                right = parse_logical_and
                left = LogicalOr.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_logical_and
            left = parse_relational
            while has('LOG_AND')
                token = capture
                right = parse_relational
                left = LogicalAnd.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_relational
            left = parse_bitwise
            while has_relational_operator
                token = capture
                right = parse_bitwise
                model_class = case token.type
                            when 'EQUAL' then Equals
                            when 'NOT_EQUAL' then NotEquals
                            when 'LESS' then LessThan
                            when 'LESS_OR_EQUAL' then LessOrEqual
                            when 'GREATER' then GreaterThan
                            when 'GREATER_OR_EQUAL' then GreaterOrEqual
                            else
                                raise "Unknown relational operator: #{token.type}"
                            end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def has_relational_operator
        if @current_token == nil
            return
        end

        @current_token.type == 'EQUAL' ||
        @current_token.type == 'NOT_EQUAL' ||
        @current_token.type == 'LESS' ||
        @current_token.type == 'LESS_OR_EQUAL' ||
        @current_token.type == 'GREATER' ||
        @current_token.type == 'GREATER_OR_EQUAL'
    end

    def parse_bitwise
            left = parse_shift
            while has_bitwise_operator
                token = capture
                right = parse_shift

                model_class = case token.type
                              when 'BIT_OR' then BitwiseOr
                              when 'BIT_AND' then BitwiseAnd
                              when 'BIT_XOR' then BitwiseXOr
                              else
                                raise "Unknown bitwise operator: #{token.type}"
                              end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def has_bitwise_operator
        if @current_token == nil
            return
        end
        @current_token.type == 'BIT_OR' ||
        @current_token.type == 'BIT_AND' ||
        @current_token.type == 'BIT_XOR'
    end

    def parse_shift
            left = parse_additive
            while has('LEFT_SHIFT') || has('RIGHT_SHIFT')
                tokne = capture
                right = parse_additive

                model_class = case token.type
                              when 'LEFT_SHIFT' then LeftShift
                              when 'RIGHT_SHIFT' then RightShift
                              else
                                raise "Unknown bitwise shift operator: #{token.type}"
                              end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_additive
            left = parse_multiplicative
            while has('ADD') || has('SUBTRACT')
                token = capture
                right = parse_multiplicative

                model_class = case token.type
                              when 'ADD' then Add
                              when 'SUBTRACT' then Subtract
                              else
                                raise "Unknown additive operator: #{token.type}"
                              end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_multiplicative
            left = parse_exponent
            while has_multiplicative_operator
                token = capture
                right = parse_exponent

                model_class = case token.type
                              when 'MULTIPLY' then Multiply
                              when 'DIVIDE' then Divide
                              when 'MODULO' then Modulo
                              else
                                raise "Unknown multiplicative operator: #{token.type}"
                              end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        #end
        left
    end

    def has_multiplicative_operator
        if @current_token == nil
            return
        end
        @current_token.type == 'MULTIPLY' ||
        @current_token.type == 'DIVIDE' ||
        @current_token.type == 'MODULO'
    end

    def parse_exponent
            left = parse_cast
            while has('POWER')
                token = capture
                right = parse_cast
                left = Exponent.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_cast
            left = parse_not
            while has('FLOAT_TO_INT') || has('INT_TO_FLOAT')
                token = capture
                right = parse_not

                model_class = case token.type
                              when 'FLOAT_TO_INT' then FloatToInt
                              when 'INT_TO_FLOAT' then IntToFloat
                              else
                                raise "Unknown cast operator: #{token.type}"
                              end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_not
            left = parse_atom
            while has('BIT_NOT') || has('LOG_NOT')
                token = capture
                right = parse_atom

                model_class = case token.type
                              when 'BIT_NOT' then BitwiseNot
                              when 'LOG_NOT' then LogicalNot
                              else
                                raise "Unknown unary operator: #{token.type}"
                              end
                left = model_class.new(left, right, left.start_index, right.end_index)
            end
        left
    end

    def parse_atom
        token = capture
        if token == nil
            return
        end
        case token.type
        when 'INT_LITERAL'
            IntegerPrimitive.new(token.text.to_i, token.start_index, token.end_index)
        when 'FLOAT_LITERAL'
            FloatPrimitive.new(token.text.to_f, token.start_index, token.end_index)
        when 'BOOLEAN_LITERAL'
            BooleanPrimitive.new(token.text == 'true', token.start_index, token.end_index)
        when 'STRING_LITERAL'
            StringPrimitive.new(token.text, token.start_index, token.end_index)
        else
            raise "Unexpected token in parse_atom: #{token.type} at (#{token.start_index},
                  #{token.end_index})"
        end
    end
end

# test

puts "----- test one -----"
code = "false || 10 > 1"
puts code
lexer = Lexer.new(code)
tokens = lexer.lex
parser = Parser.new(tokens)
ast = parser.parse
puts ast

grid = Grid.new(5, 5)
environment = Environment.new(grid)
puts ast.evaluate(environment)
