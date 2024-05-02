module Expression
    def evaluate(environment)
        raise NotImplementedError, "Subclass must implement the evaluate method."
    end

    def to_s
        raise NotImplementedError, "Subclass must implement the to_s method."
    end
end