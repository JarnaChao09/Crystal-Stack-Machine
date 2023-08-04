module StackMachine
  enum Comparison
    LT
    LE
    GT
    GE
    EQ
    NE

    def call(l : Float64, r : Float64) : Bool
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
