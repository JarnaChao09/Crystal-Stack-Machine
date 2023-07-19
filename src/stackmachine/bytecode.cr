require "./operations"
require "./comparisons"
require "./opcode"

module StackMachine
  alias Bytecode = Int32 | OpCode | Operation | Comparison
end
