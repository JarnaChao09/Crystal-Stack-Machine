require "./bytecode"

module StackMachine
  # Type alias for use in locals.
  # Current max amount of locals is `8`.
  alias LocalArray = Int32[8]

  # Given an input array following the Reverse Polish Notation format, this method will execute the RPN expression.
  #
  # ```
  # StackMachine.execute [1, 2, StackMachine::Operation::Add] # => 3
  # StackMachine.execute [1, 2, StackMachine::Operation::Div] # => 0
  # ```
  #
  # Use of `Load` and `Store` opcodes can allow for variables
  #
  # ```
  # StackMachine.execute [1, Store.new 0, Load.new 0] # => 1
  # ```
  #
  # TODO: create new exceptions for when there are an invalid number of operands on stack and when stack has too many values at the end
  def self.execute(code : Array(Bytecode)) : Int32
    stack = [] of Int32
    locals = LocalArray.new { 0 }
    code.each_with_index do |x, i|
      case x
      in Operation
        begin
          a, b = stack.pop 2
          stack.push x.call a, b
        rescue
          raise Exception.new "Invalid Number of Operands on the stack for Operation #{x}"
        end
      in Int32
        stack.push x
      in Load
        x.call do |locals_index|
          stack.push locals[locals_index]
        end
      in Store
        x.call do |locals_index|
          locals[locals_index] = stack.pop
        end
      end
    end
    raise Exception.new "Too many or not enough values on the stack" unless stack.size == 1
    stack.pop
  end
end
