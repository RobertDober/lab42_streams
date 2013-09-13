require 'spec_helper'

describe Lab42::Stream::Empty do 
  subject{ empty_stream }

  context "is an Enumerable" do 
    it "is empty indeed" do
      should be_empty
    end
    it "is also empty ;)" do
      expect( subject.to_a ).to be_empty
    end
    it "can be lazy, but remains empty" do
      expect( subject.lazy.to_a ).to be_empty
    end
  end # context "is an Enumerable"
end # describe Lab42::Stream::Empty
