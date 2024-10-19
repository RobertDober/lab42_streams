# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate command line
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:21
  context "Import the basic functions into the Kernel (`cons_stream` and `the empty_stream`) and Lab42::Stream into main" do
    # README.md:24
    require 'lab42/stream/basic_imports'
    it "we have access to the_empty_stream (README.md:28)" do
      expect(the_empty_stream).to be_kind_of(EmptyStream)
    end
    it "to cons_stream (README.md:32)" do
      expect(cons_stream(1) {1}).to be_kind_of(Stream)
    end
    it "we can see the difference between both (README.md:36)" do
      expect(the_empty_stream).to be_empty
      expect(cons_stream(1) {1}).not_to be_empty
    end
  end
  # README.md:41
  context "Basic operations" do
    # README.md:46
    def integers_from(n=0) = cons_stream(n){ integers_from(n+1) }
    let(:integers) { integers_from }
    it "we access `head` and `tail` of the integers as follows (README.md:52)" do
      expect(integers.head).to eq(0)
      expect(integers.tail).to be_a(Stream)
      expect(integers.tail.tail.head).to eq(2)
    end
    it "we shall be carefull about the empty stream (README.md:59)" do
      expect { the_empty_stream.tail }.to raise_error(StopIteration)
      expect { the_empty_stream.head }.to raise_error(StopIteration)
    end
    it "this can be used to create finite streams (README.md:65)" do
      binaries = cons_stream(0) { cons_stream(1, the_empty_stream) }
      result = []
      loop do
      result << binaries.head
      binaries = binaries.tail
      end
      expect(result).to eq([0, 1])
    end
  end
  # README.md:77
  context "`Enumerable`" do
    it "we can see that (README.md:83)" do
      result = nil
      Stream.integers.each do |n|
      break if n>42
      result = n
      end
      expect(result).to eq(42)
    end
    it "that we get all the Enumerable goodies too (README.md:93)" do
      expect(Stream.integers.drop(2).take(3).reduce(&:+)).to eq(9)
    end
  end
end