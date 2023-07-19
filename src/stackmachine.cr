require "./stackmachine/*"

def prompt(line : String) : String | Nil
  print line
  gets
end

def fib(n : Int32) : Int32
  return 0 if n == 0

  a, b = 0, 1

  (n - 1).times do 
    c = a + b
    a = b
    b = c
  end

  return b
end

def main
  n = prompt("N = ").not_nil!.to_i
  puts "Calculating fib(n) for n = #{n}"
  puts "Crystal code fib(#{n}) = #{fib(n)}"
  bytecode = StackMachine.build {
    # n = input
    op_num n                            # 1
    op_store 0                          # 2

    # n == 0
    op_load 0                           # 3
    op_num 0                            # 4
    op_eq                               # 5

    # if n == 0
    op_jmpf 9                           # 6

    # true branch of if n == 0
    op_num 0                            # 7
    op_jump 100 # exit early            # 8

    # false branch of if n == 0
    # a = 0
    op_num 0                            # 9
    op_store 1                          # 10
    
    # b = 1
    op_num 1                            # 11
    op_store 2                          # 12

    # i = 0
    op_num 0                            # 13
    op_store 3                          # 14

    # n - 1
    op_load 0                           # 15
    op_num 1                            # 16
    op_sub                              # 17
    op_store 4                          # 18

    # i < n - 1
    op_load 3                           # 19
    op_load 4                           # 20
    op_lt                               # 21

    # while i < n - 1
    op_jmpf 36                          # 22
    
    # c = a + b
    op_load 1                           # 23  
    op_load 2                           # 24
    op_add                              # 25
    op_store 5                          # 26

    # a = b
    op_load 2                           # 27
    op_store 1                          # 28

    # b = c
    op_load 5                           # 29
    op_store 2                          # 30

    # i += 1
    op_load 3                           # 31
    op_num 1                            # 32
    op_add                              # 33
    op_store 3                          # 34

    # while i < n - 1 end
    op_jump 19                          # 35

    # return b
    op_load 2                           # 36
  }
  ans = StackMachine.execute bytecode
  puts "VM fib(#{n}) = #{ans}"
rescue ex
  puts ex.message
end

main
