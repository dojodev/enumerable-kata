shared_examples_for :enumerable_take do |method_name|
  before :each do
    @values = [4,3,2,1,0,-1]
    @enum = EnumerableSpecs::Numerous.new(*@values)
  end

  it "returns the first count elements if given a count" do
    @enum.send(method_name, 2).should == [4, 3]
    @enum.send(method_name, 4).should == [4, 3, 2, 1] # See redmine #1686 !
  end

  it "returns an empty array when passed count on an empty array" do
    empty = EnumerableSpecs::Empty.new
    empty.send(method_name, 0).should == []
    empty.send(method_name, 1).should == []
    empty.send(method_name, 2).should == []
  end

  it "returns an empty array when passed count == 0" do
    @enum.send(method_name, 0).should == []
  end

  it "returns an array containing the first element when passed count == 1" do
    @enum.send(method_name, 1).should == [4]
  end

  it "raises an ArgumentError when count is negative" do
    lambda { @enum.send(method_name, -1) }.should raise_error(ArgumentError)
  end

  it "returns the entire array when count > length" do
    @enum.send(method_name, 100).should == @values
    @enum.send(method_name, 8).should == @values  # See redmine #1686 !
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = mock('to_int')
    obj.should_receive(:to_int).at_most(:twice).and_return(3) # called twice, no apparent reason. See redmine #1554
    @enum.send(method_name, obj).should == [4, 3, 2]
  end

  it "raises a TypeError if the passed argument is not numeric" do
    lambda { @enum.send(method_name, nil) }.should raise_error(TypeError)
    lambda { @enum.send(method_name, "a") }.should raise_error(TypeError)

    obj = mock("nonnumeric")
    lambda { @enum.send(method_name, obj) }.should raise_error(TypeError)
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = EnumerableSpecs::YieldsMulti.new
    multi.send(method_name, 1).should == [[1, 2]]
  end

  ruby_bug "#1554", "1.9.1" do
    it "consumes only what is needed" do
      thrower = EnumerableSpecs::ThrowingEach.new
      thrower.send(method_name, 0).should == []
      counter = EnumerableSpecs::EachCounter.new(1,2,3,4)
      counter.send(method_name, 2).should == [1,2]
      counter.times_called.should == 1
      counter.times_yielded.should == 2
    end
  end
end
