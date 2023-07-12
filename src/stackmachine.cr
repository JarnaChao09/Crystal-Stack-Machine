require "./stackmachine/*"

def main
  puts StackMachine.execute [
    10, 
    20, 
    StackMachine::Operation::Add, 
    30, 
    40, 
    StackMachine::Operation::Add, 
    50, 
    StackMachine::Operation::Add, 
    StackMachine::Operation::Add
  ]
  # puts StackMachine.execute [10, 20, StackMachine::Operation::Add, 30, 40, StackMachine::Operation::Add, 50]
  # puts StackMachine.execute [StackMachine::Operation::Add]
rescue ex
  puts ex.message
end

main
