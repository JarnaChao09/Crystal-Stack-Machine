require "./comparisons"
require "./operations"
require "./opcode"
require "./value"

module StackMachine
  alias Bytecode = Value | OpCode | Operation | Comparison
end
