require "./operations"

module StackMachine
  # Given an input array following the Reverse Polish Notation format, this method will execute the RPN expression.
  #
  # ```
  # StackMachine.execute [1, 2, StackMachine::Operation::Add] # => 3
  # StackMachine.execute [1, 2, StackMachine::Operation::Div] # => 0
  # ```
  #
  # TODO: create new exceptions for when there are an invalid number of operands on stack and when stack has too many values at the end
  def self.execute(code : Array(Int32 | Operation)) : Int32
    stack = [] of Int32
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
      end
    end
    raise Exception.new "Too many values still on the stack" unless stack.size == 1
    stack.pop
  end
end
