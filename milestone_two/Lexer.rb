=begin
# define lexer that accepts an expression in text form and tokenizes it into a list
# of tokens. For example, lexing the expression 5 <= 32.0 yields this list in pseudocode:
    [
        (:integer_literal, "5", 0, 0),
        (:less_than_equal, "<=", 2, 3),
        (:float_literal, "32.0", 5, 8)
    ]
follow strategy for designing lexers described in the reading and lecture; ensure that
lexer does not overstep its bounds; it doesn't try to make sense of tokens, reference
any of your model classes, or evaluate anything
=end


=begin
if (has('"')) { # has checks if theres a character to read and that it matches target
    skip();
    while (hasNot('"')) { # hasNot checks if there is character to read that does not match target
        if (has('\\')) {
            skip(); # doesn't include current character but continues lexing token at next character
        }
        capture(); # adds current character to token being recognized and moves to next character
    }
    if (has('"')) {
        skip();
        emitToken('string-literal');
    } else {
        throw 'unclosed string literal'
    }
}

# example lexer for a language of addition expressions like 7 + 3
function lex(code) {
    let i = 0;
    let tokenSoFar = '';
    let tokens = [];

    # check if current character is target
    function has(target) {
        return i < code.length && code.charAt(i) === target;
    }

    # check if current character is not target
    function hasNot(target) {
        return i < code.length && code.charAt(i) !== target;
    }

    # check if current character is a digit
    function hasDigit() {
        return i < code.length && '0' <= code.charAt(i) && code.charAt(i) <= '9';
    }

    # add current character to token and move along
    function capture() {
        tokenSoFar += code.charAt(i);
        i = i + 1;
    }

    # ignore character, reset token
    function abandon() {
        i = i + 1;
        tokenSoFar = '';
    }

    # ignore character, but don't reset token
    function skip() {
        i = i + 1;
    }

    # append the accumulated token to the list and reset
    functin emitToken(kind) {
        tokens.push({kind, token: tokenSoFar});
        tokenSoFar = '';
    }

    while (i < code.length) {
        if (has(' ')) {
            abandon();
        } elsif (has('+')) {
            capture();
            emitToken('plus');
        } elsif (hasDigit()) {
            while (hasDigit()) {
                capture();
            }
            emitToken('integer-literal');
        } else {
            throw 'error'
        }
    }

    return tokens;
}
=end
require_relative 'Tokens'

class Lexer
    def initialize(code)
        @i = 0
        @token_so_far = ''
        @tokens = []
        @code = code
    end

    def lex
        while @i < @code.length
            case
            when has(' ')
                abandon
            when has('|') && has('|', offset: 1)
                capture
                capture
                emit_token('LOG_OR', @i - 2, @i - 1)
            when has('|')
                capture
                emit_token('BIT_OR', @i - 1, @i - 1)
            when has('&') && has('&', offset: 1)
                capture
                capture
                emit_token('LOG_AND', @i - 2, @i - 1)
            when has('&')
                capture
                emit_token('BIT_AND', @i - 1, @i - 1)
            when has('=') && has('=', offset: 1)
                capture
                capture
                emit_token('EQUAL', @i - 2, @i - 1)
            when has('!') && has('=', offset: 1)
                capture
                capture
                emit_token('NOT_EQUAL', @i - 2, @i - 1)
            when has('<') && has('<', offset: 1)
                capture
                capture
                emit_token('LEFT_SHIFT', @i - 2, @i - 1)
            when has('>') && has('>', offset: 1)
                capture
                capture
                emit_token('RIGHT_SHIFT', @i - 2, @i - 1)
            when has('<') && has('=', offset: 1)
                capture
                capture
                emit_token('LESS_OR_EQUAL', @i - 2, @i - 1)
            when has('<')
                capture
                emit_token('LESS', @i - 1, @i - 1)
            when has('>') && has('=', offset: 1)
                capture
                capture
                emit_token('GREATER_OR_EQUAL', @i - 2, @i - 1)
            when has('>')
                capture
                emit_token('GREATER', @i - 1, @i - 1)
            when has('^')
                capture
                emit_token('BIT_XOR', @i - 1, @i - 1)
            when has('*') && has('*', offset: 1)
                capture
                capture
                emit_token('POWER', @i - 2, @i - 1)
            when has('+')
                capture
                emit_token('ADD', @i - 1, @i - 1)
            when has('-')
                capture
                emit_token('SUBTRACT', @i - 1, @i - 1)
            when has('*')
                capture
                emit_token('MULTIPLY', @i - 1, @i - 1)
            when has('/')
                capture
                emit_token('DIVIDE', @i - 1, @i - 1)
            when has('%')
                capture
                emit_token('MODULO', @i - 1, @i - 1)
            when has('t') && has('o', offset: 1) && has('_', offset: 2) && has('i', offset: 3)
                capture
                capture
                capture
                capture
                emit_token('FLOAT_TO_INT', @i - 4, @i - 1)
            when has('t') && has('o', offset: 1) && has('_', offset: 2) && has('f', offset: 3)
                capture
                capture
                capture
                capture
                emit_token('INT_TO_FLOAT', @i - 4, @i - 1)
            when has('~')
                capture
                emit_token('BIT_NOT', @i - 1, @i - 1)
            when has('!')
                capture
                emit_token('LOG_NOT', @i - 1, @i - 1)
            when has('(')
                capture
                emit_token('LEFT_PAREN', @i - 1, @i - 1)
            when has(')')
                capture
                emit_token('RIGHT_PAREN', @i - 1, @i - 1)
            when has_digit
                float = false
                j = 0
                while has_digit
                    capture
                    j += 1
                end
                if has('.')
                    if @code[@i + 1] =~ /[0-9]/
                        capture
                        capture
                        j += 2
                        float = true
                    end
                end
                while has_digit
                    capture
                    j += 1
                end
                if float
                    emit_token('FLOAT_LITERAL', @i - j, @i - 1 )
                else
                    emit_token('INT_LITERAL', @i - j, @i - 1)
                end
            when has("'")
                capture
                while has_not("'")
                    if has("\\")
                        skip
                    end
                    capture
                end
                if has("'")
                    skip
                    emit_token('STRING_LITERAL', @i-@token_so_far.length, @i - 1)
                else
                    raise 'Unclosed string literal'
                end
            when has('"')
                capture
                while has_not('"')
                    if has("\\")
                        skip
                    end
                    capture
                end
                if has('"')
                    skip
                    emit_token('STRING_LITERAL', @i - @token_so_far.length, @i - 1)
                else
                    raise 'Unclosed string literal'
                end
            when has('t') && has('r', offset: 1) && has('u', offset: 2) && has('e', offset: 3)
                capture
                capture
                capture
                capture
                emit_token('BOOLEAN_LITERAL', @i - 5, @i - 1)
            when has('f') && has('a', offset: 1) && has('l', offset: 2) && has('s', offset: 3) && has('e', offset: 4)
                capture
                capture
                capture
                capture
                capture
                emit_token('BOOLEAN_LITERAL', @i - 5, @i - 1)
            else
                raise "Unexpected character: #{@code[@i]}"
            end
        end
        @tokens
    end


    private

    # check if current character is target
    # use offset to keep track of i when checking for multi-character operators like ||
    def has(target, offset: 0)
        @i + offset < @code.length && @code[@i + offset] == target
    end

    # check if current character is not target
    # use offset to keep track of i when checkingn for multi-character operators like ||
    def has_not(target, offset: 0)
        @i + offset< @code.length && @code[@i + offset] != target
    end

    # check if current character is a digit
    def has_digit
        @i < @code.length && @code[@i] =~ /[0-9]/
    end

    # check if current character is letter or underscore
    def has_letter
        @i < @code.length && @code[@i] =~ /[a-zA-Z_]/
    end

    # add current character to token and move along
    def capture
        @token_so_far += @code[@i]
        @i += 1
    end

    # ignore character, reset token
    def abandon
        @i += 1
        @token_so_far = ''
    end

    # ignore character, but don't reset token
    def skip
        @i += 1
    end

    # append the accumulated token to the list and reset
    def emit_token(type, start, end_index)
        @tokens.push(Token.new(type, @token_so_far, start, end_index))
        @token_so_far = ''
    end
end

# test
=begin
code = "5 <= 32"
lexer = Lexer.new(code)
tokens = lexer.lex
tokens.each { |token| puts token.to_s }
=end