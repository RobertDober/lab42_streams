require 'spec_helper'

describe Lab42::Stream::Empty do 
  context "is a singleton" do 
    it "there can only be one" do
      expect(
        described_class.new
      ).to equal( described_class.new )
    end

    it "has a nice shiny little name in Kernel" do
      expect(
        described_class.new
      ).to equal( empty_stream )
    end
  end # context "is a singleton"
end # describe Lab42::Stream::Empty
