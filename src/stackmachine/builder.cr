require "./bytecode"

module StackMachine
  # Helper class to build stack vm bytecode
  # Class is only available through `StackMachine.build` method
  private class Builder
    # Create a builder with an empty set of instructions
    def initialize
      @instructions = [] of Bytecode
    end

    # Return the built instructions
    def build : Array(Bytecode)
      @instructions
    end

    # Opcode helper method for adding an integer instruction
    def op_num(n : Int32)
      @instructions << n
    end

    # Opcode helper method for adding an add instruction
    def op_add
      @instructions << Operation::Add
    end

    # Opcode helper method for adding a sub instruction
    def op_sub
      @instructions << Operation::Sub
    end

    # Opcode helper method for adding a mul instruction
    def op_mul
      @instructions << Operation::Mul
    end

    # Opcode helper method for adding a div instruction
    def op_div
      @instructions << Operation::Div
    end

    # Opcode helper method for adding a lt instruction
    def op_lt
      @instructions << Comparison::LT
    end

    # Opcode helper method for adding a le instruction
    def op_le
      @instructions << Comparison::LE
    end

    # Opcode helper method for adding a gt instruction
    def op_gt
      @instructions << Comparison::GT
    end

    # Opcode helper method for adding a ge instruction
    def op_ge
      @instructions << Comparison::GE
    end

    # Opcode helper method for adding a eq instruction
    def op_eq
      @instructions << Comparison::EQ
    end

    # Opcode helper method for adding a ne instruction
    def op_ne
      @instructions << Comparison::NE
    end

    # Opcode helper method for adding a load instruction
    def op_load(n : Int32)
      @instructions << Load.new n
    end

    # Opcode helper method for adding a store instruction
    def op_store(n : Int32)
      @instructions << Store.new n
    end

    # Opcode helper method for adding a jump instruction
    def op_jump(i : Int32)
      @instructions << Jump.new i - 1
    end

    # Opcode helper method for adding a jmpt instruction
    def op_jmpt(i : Int32)
      @instructions << JumpTrue.new i - 1
    end

    # Opcode helper method for adding a jmpf instruction
    def op_jmpf(i : Int32)
      @instructions << JumpFalse.new i - 1
    end
  end

  # Method to build the stack vm bytecode
  # Use of `with ... yield` to make the `Builder` class the receiver
  #
  # ```
  # bytecode = StackMachine.build {
  #   op_num 10
  #   op_num 20
  #   op_add
  #   op_num 40
  #   op_num 30
  #   op_sub
  #   op_num 3
  #   op_mul
  #   op_div
  # }
  #
  # StackMachine.execute bytecode # => 1
  # ```
  def self.build(&) : Array(Bytecode)
    builder = Builder.new
    with builder yield
    builder.build
  end
end
