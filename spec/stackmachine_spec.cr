require "./spec_helper"

describe StackMachine do
  it "10 20 + 30 40 + 50 + + = 150" do
    (StackMachine.execute [
      10,
      20,
      StackMachine::Operation::Add,
      30,
      40,
      StackMachine::Operation::Add,
      50,
      StackMachine::Operation::Add,
      StackMachine::Operation::Add,
    ]).should eq(150)
  end

  it "1 2 + = 3" do
    (StackMachine.execute [
      1,
      2,
      StackMachine::Operation::Add,
    ]).should eq(3)
  end

  it "1 2 - = -1" do
    (StackMachine.execute [
      1,
      2,
      StackMachine::Operation::Sub,
    ]).should eq(-1)
  end

  it "1 2 * = 2" do
    (StackMachine.execute [
      1,
      2,
      StackMachine::Operation::Mul,
    ]).should eq(2)
  end

  it "1 2 / = 0" do
    (StackMachine.execute [
      1,
      2,
      StackMachine::Operation::Div,
    ]).should eq(0)
  end

  it "4 2 / = 2" do
    (StackMachine.execute [
      4,
      2,
      StackMachine::Operation::Div,
    ]).should eq(2)
  end

  it "4 + should raise invalid number of operands" do
    expect_raises(Exception) do
      StackMachine.execute [
        4,
        StackMachine::Operation::Add,
      ]
    end
  end

  it "4 2 / 2 should raise stack has too many values" do
    expect_raises(Exception) do
      StackMachine.execute [
        4,
        2,
        StackMachine::Operation::Div,
        2,
      ]
    end
  end

  it "Testing op_num builder method" do
    StackMachine.build {
      op_num 100
    }.should eq([100] of StackMachine::Bytecode)
  end

  it "Testing op_add builder method" do
    StackMachine.build {
      op_num 100
      op_num 200
      op_add
    }.should eq([100, 200, StackMachine::Operation::Add] of StackMachine::Bytecode)
  end

  it "Testing op_sub builder method" do
    StackMachine.build {
      op_num 200
      op_num 100
      op_sub
    }.should eq([200, 100, StackMachine::Operation::Sub] of StackMachine::Bytecode)
  end

  it "Testing op_mul builder method" do
    StackMachine.build {
      op_num 3
      op_num 4
      op_mul
    }.should eq([3, 4, StackMachine::Operation::Mul] of StackMachine::Bytecode)
  end

  it "Testing op_div builder method" do
    StackMachine.build {
      op_num 4
      op_num 2
      op_div
    }.should eq([4, 2, StackMachine::Operation::Div] of StackMachine::Bytecode)
  end

  it "Testing op_load op_store builder method" do
    StackMachine.build {
      op_num 100
      op_store 0
      op_load 0
    }.should eq([100, StackMachine::Store.new(0), StackMachine::Load.new(0)] of StackMachine::Bytecode)
  end

  it "100 store 0 load 0 = 100" do
    (StackMachine.execute [
      100,
      StackMachine::Store.new(0),
      StackMachine::Load.new(0),
    ]).should eq(100)
  end
end
