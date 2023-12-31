require "./bytecode"

module StackMachine
  # Type alias for use in locals.
  # Current max amount of locals is `8`.
  alias LocalArray = (Float64 | Bool)[8]

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
  def self.execute(code : Array(Bytecode)) : Float64 | Bool
    labels = {} of Symbol => Int32
    stack = [] of Float64 | Bool
    locals = LocalArray.new { 0.0 }

    code.each_with_index do |x, i|
      if x.is_a? Label
        x.call do |identifier|
          labels[identifier] = i
        end
      end
    end

    i = labels[:main]
    while i < code.size
      x = code[i]
      case x
      in Operation
        begin
          a, b = stack.pop 2
          case {a, b}
          in {Float64, Float64}
            stack.push x.call a, b
          in {_, _}
            raise Exception.new "Invalid types for Operation #{x}, expected Int32, Int32"
          end
        rescue IndexError
          raise Exception.new "Invalid Number of Operands on the stack for Operation #{x}"
        end
      in Comparison
        begin
          a, b = stack.pop 2
          case {a, b}
          in {Float64, Float64}
            stack.push x.call a, b
          in {_, _}
            raise Exception.new "Invalid types for Operation #{x}, expected Int32, Int32"
          end
        rescue IndexError
          raise Exception.new "Invalid Number of Operands on the stack for Comparison #{x}"
        end
      in Int32
        stack.push x.to_f
      in Float64
        stack.push x
      in OpCode
        case x
        in Load
          x.call do |locals_index|
            stack.push locals[locals_index]
          end
        in Store
          x.call do |locals_index|
            locals[locals_index] = stack.pop
          end
        in Label
          # noop
        in Jump
          x.call do |jump_index|
            case jump_index
            in Int32
              i = jump_index - 2
            in Symbol
              i = labels[jump_index]
            end
          end
        in JumpForward
          x.call do |delta|
            i += delta - 1
          end
        in JumpBackward
          x.call do |delta|
            i -= delta + 1
          end
        in JumpTrue
          x.call do |jump_index|
            top = stack.pop
            case top
            when true
              case jump_index
              in Int32
                i = jump_index - 2
              in Symbol
                i = labels[jump_index]
              end
            when false
            else
              raise Exception.new "Expected top of stack to be Bool, found #{typeof(top)}"
            end
          end
        in JumpTrueForward
          x.call do |delta|
            top = stack.pop
            case top
            when true
              i += delta - 1
            when false
            else
              raise Exception.new "Expected top of stack to be Bool, found #{typeof(top)}"
            end
          end
        in JumpTrueBackward
          x.call do |delta|
            top = stack.pop
            case top
            when true
              i -= delta + 1
            when false
            else
              raise Exception.new "Expected top of stack to be Bool, found #{typeof(top)}"
            end
          end
        in JumpFalse
          x.call do |jump_index|
            top = stack.pop
            case top
            when true
            when false
              case jump_index
              in Int32
                i = jump_index - 2
              in Symbol
                i = labels[jump_index]
              end
            else
              raise Exception.new "Expected top of stack to be Bool, found #{typeof(top)}"
            end
          end
        in JumpFalseForward
          x.call do |delta|
            top = stack.pop
            case top
            when true
            when false
              i += delta - 1
            else
              raise Exception.new "Expected top of stack to be Bool, found #{typeof(top)}"
            end
          end
        in JumpFalseBackward
          x.call do |delta|
            top = stack.pop
            case top
            when true
            when false
              i -= delta + 1
            else
              raise Exception.new "Expected top of stack to be Bool, found #{typeof(top)}"
            end
          end
        end
      end
      i += 1
    end

    raise Exception.new "Too many or not enough values on the stack" unless stack.size == 1

    stack.pop
  end
end
