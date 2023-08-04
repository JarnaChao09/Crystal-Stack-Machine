module StackMachine
  # Enum for every binary mathematical operaiton.
  # TODO: Figure out a scheme for unary operations.
  enum Operation
    Add
    Sub
    Mul
    Div

    # This method performs the mathematical operation represented by the enum.
    # It will always return an Int32 and truncate on division.
    #
    # ```
    # StackMachine::Operation::Add.call(1, 2) # => 3
    # StackMachine::Operation::Div.call(1, 2) # => 0
    # ```
    def call(l : Float64, r : Float64) : Float64
      case self
      in .add? then l + r
      in .sub? then l - r
      in .mul? then l * r
      in .div? then l / r
      end
    end
  end
end
