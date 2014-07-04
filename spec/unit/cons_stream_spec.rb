require 'spec_helper'

describe Lab42::Stream do 
  context "cons_stream" do 
    subject do
      cons_stream(1){
        cons_stream(2){ empty_stream }}
    end

    it "has a head" do
      expect( subject.head ).to eq 1
    end
    it "can use first for protocol unification with Enumerable" do
      expect( subject.first ).to eq 1
    end

    it "has a tail" do
      expect( subject.tail.head ).to eq 2
      expect( subject.tail.tail ).to be_empty
    end
  end # context "cons_stream"
end # describe Lab42::Stream
