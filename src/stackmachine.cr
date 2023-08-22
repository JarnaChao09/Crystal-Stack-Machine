require "./stackmachine/*"

def prompt(line : String) : String | Nil
  print line
  gets
end

def fib(n : Int32) : Int32
  return 0 if n == 0

  a, b = 0, 1

  (n - 1).times do
    a, b = b, a + b
  end

  return b
end

def main
  n = prompt("N = ").not_nil!.to_i
  puts "Calculating fib(n) for n = #{n}"
  puts "Crystal code fib(#{n}) = #{fib(n)}"
  bytecode = StackMachine.build {
    op_label :main
    # n = input
    op_num n
    op_store 0

    # n == 0
    op_load 0
    op_num 0
    op_eq

    # if n == 0
    op_jmpf_forward 3

    # true branch of if n == 0
    op_num 0
    op_jump :exit # exit early

    # false branch of if n == 0
    # a = 0
    op_num 0
    op_store 1

    # b = 1
    op_num 1
    op_store 2

    # i = 0
    op_num 0
    op_store 3

    # n - 1
    op_load 0
    op_num 1
    op_sub
    op_store 4

    op_label :loop_start

    # i < n - 1
    op_load 3
    op_load 4
    op_lt

    # while i < n - 1
    op_jmpf :loop_end

    # c = a + b
    op_load 1
    op_load 2
    op_add
    op_store 5

    # a = b
    op_load 2
    op_store 1

    # b = c
    op_load 5
    op_store 2

    # i += 1
    op_load 3
    op_num 1
    op_add
    op_store 3

    # while i < n - 1 end
    op_jump :loop_start

    op_label :loop_end

    # return b
    op_load 2

    # label for early exit
    op_label :exit
  }
  ans = StackMachine.execute bytecode
  puts "VM fib(#{n}) = #{ans}"
rescue ex
  puts ex.message
end

main
