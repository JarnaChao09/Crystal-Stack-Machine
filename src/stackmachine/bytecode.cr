require "./operations"
require "./comparisons"
require "./opcode"

module StackMachine
  alias Bytecode = Int32 | Float64 | OpCode | Operation | Comparison
end
