module StackMachine
  private macro define_unary_opcode(opcode_name, field_name, field_type)
    # Struct for `{{ opcode_name }}` opcode
    struct {{ opcode_name }}
      def initialize(@{{ field_name }} : {{ field_type }})
      end

      # Pass in a block to perform specified operation with the underlying {{ field_name }}
      #
      # ```
      # {{ opcode_name }}.new.call do | {{ field_name }} |
      #   do_something_with {{ field_name }}
      # end
      # ```
      def call(& : {{ field_type }} -> ) : Void
        yield @{{ field_name }}
      end
    end
  end

  define_unary_opcode Load, index, Int32
  define_unary_opcode Store, index, Int32

  define_unary_opcode Jump, index, (Int32)
  define_unary_opcode JumpForward, delta, Int32
  define_unary_opcode JumpBackward, delta, Int32

  define_unary_opcode JumpTrue, index, (Int32)
  define_unary_opcode JumpTrueForward, delta, Int32
  define_unary_opcode JumpTrueBackward, delta, Int32

  define_unary_opcode JumpFalse, index, (Int32)
  define_unary_opcode JumpFalseForward, delta, Int32
  define_unary_opcode JumpFalseBackward, delta, Int32

  alias OpCode = Load |
                 Store |
                 Jump |
                 JumpForward |
                 JumpBackward |
                 JumpTrue |
                 JumpTrueForward |
                 JumpTrueBackward |
                 JumpFalse |
                 JumpFalseForward |
                 JumpFalseBackward
end
