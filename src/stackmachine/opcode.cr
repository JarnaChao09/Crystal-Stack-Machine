module StackMachine
  macro define_unary_opcode(opcode_name, field_name, field_type)
    class {{ opcode_name }}
      getter {{ field_name }} : {{ field_type }}

      def initialize(@{{ field_name }} : {{ field_type }})
      end

      def call(& : {{ field_type }} -> ) : Void
        yield @{{ field_name }}
      end
    end
  end

  define_unary_opcode Load, index, Int32
  define_unary_opcode Store, index, Int32
end