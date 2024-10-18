require 'spec_helper'

describe Lab42::Stream::Empty do 
  subject{ empty_stream }

  context "emptyness" do 
    it "is empty indeed" do
      should be_empty
    end
    it "to_a is also empty ;)" do
      expect( subject.to_a ).to be_empty
    end
  end # context "is an Enumerable"

  context "raises StopIteration" do 
    it "on invoking #head" do
      expect{ subject.head }.to raise_error StopIteration
    end
    it "on invoking #tail" do
      expect{ subject.tail }.to raise_error StopIteration
    end
  end # context "raises StopIteration"
end # describe Lab42::Stream::Empty
