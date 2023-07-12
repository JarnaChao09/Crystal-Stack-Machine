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
end
