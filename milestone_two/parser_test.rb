require 'test/unit'
require_relative 'Lexer'
require_relative 'Parser'
require_relative '../milestone_one/Grid'
require_relative '../milestone_one/Environment'

class ParserTest < Test::Unit::TestCase

    def test_integer_expression
        code = '12'
        expected = IntegerPrimitive.new(12, 0, 1)

        lexer = Lexer.new(code)
        tokens = lexer.lex
        parser = Parser.new(tokens)
        ast = parser.parse
        puts "Parser output: #{ast}"

        grid = Grid.new(5, 5)
        environment = Environment.new(grid)

        assert_equal(expected.evaluate(environment), ast.evaluate(environment))
    end

    def test_relational_expression
        code = '5 <= 32'
        expected = LessOrEqual.new(
                    IntegerPrimitive.new(5, 0, 0),
                    IntegerPrimitive.new(32, 5, 6),
                    0, 6)

        lexer = Lexer.new(code)
        tokens = lexer.lex
        parser = Parser.new(tokens)
        ast = parser.parse
        puts "Parser output: #{ast}"

        grid = Grid.new(5, 5)
        environment = Environment.new(grid)
        assert_equal(expected.evaluate(environment).boolean, ast.evaluate(environment).boolean)
    end

    def test_arithmetic_expression
        code = "10 - 8 * 5 + 45"
        expected = 15
        lexer = Lexer.new(code)
        tokens = lexer.lex
        parser = Parser.new(tokens)
        ast = parser.parse
        puts "Parser output: #{ast}"

        grid = Grid.new(5, 5)
        environment = Environment.new(grid)
        assert_equal(expected, ast.evaluate(environment))

        code = "25 / 5 % 5 + 23"
        expected = 23
        lexer = Lexer.new(code)
        tokens = lexer.lex
        parser = Parser.new(tokens)
        ast = parser.parse
        puts "Parser output: #{ast}"

        assert_equal(expected, ast.evaluate(environment))
    end

    def test_logical_expression
        code = "4 < 3 && 5 > 1"
        expected = false
        lexer = Lexer.new(code)
        tokens = lexer.lex
        parser = Parser.new(tokens)
        ast = parser.parse
        puts "Parser output: #{ast}"

        grid = Grid.new(5, 5)
        environment = Environment.new(grid)
        assert_equal(expected, ast.evaluate(environment).boolean)

        code = "false || 10 > 1"
        expected = true
        lexer = Lexer.new(code)
        tokens = lexer.lex
        parser = Parser.new(tokens)
        ast = parser.parse
        puts "Parser output: #{ast}"

        assert_equal(expected, ast.evaluate(environment).boolean)
    end
end