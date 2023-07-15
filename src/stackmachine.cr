require "./stackmachine/*"

def main
  bytecode = StackMachine.build {
    op_num 10
    op_num 20
    op_add
    op_num 40
    op_num 30
    op_sub
    op_num 3
    op_mul
    op_div
  }
  ans = StackMachine.execute bytecode
  puts ans
rescue ex
  puts ex.message
end

main
