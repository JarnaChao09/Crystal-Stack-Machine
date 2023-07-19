module StackMachine
  enum Comparison
    LT
    LE
    GT
    GE
    EQ
    NE

    def call(l : Int32, r : Int32) : Bool
      case self
      in .lt? then l < r
      in .le? then l <= r
      in .gt? then l > r
      in .ge? then l >= r
      in .eq? then l == r
      in .ne? then l != r
      end
    end
  end
end
