require "./stackmachine/*"

def main
  bytecode = StackMachine.build {
    # a = 1 | #0 = 1
    op_num 1
    op_store 0

    # b = 2 | #1 = 2
    op_num 2
    op_store 1

    # c = a + b | #2 = #0 + #1 | #2 = 3
    op_load 0
    op_load 1
    op_add
    op_store 2

    # d = 3 * a | #3 = 3 * #0 | #3 = 3
    op_num 3
    op_load 0
    op_mul
    op_store 3

    # e = c - b | #4 = #2 - #1 | #4 = 1
    op_load 2
    op_load 1
    op_sub
    op_store 4

    # f = d / 3 | #5 = #3 /  3 | #5 = 1
    op_load 3
    op_num 3
    op_div
    op_store 5

    op_load 0
  }
  ans = StackMachine.execute bytecode
  puts ans
rescue ex
  puts ex.message
end

main
