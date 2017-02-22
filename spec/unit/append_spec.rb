require 'spec_helper'

describe Lab42::Stream do
  context :append do
    it "two finite streams" do
      expect( finite_stream([1,2]).append( finite_stream [3] ).to_a ).to eq([1,2,3])
    end
    
    it "a finite stream and an empty stream" do
      expect(
        finite_stream( %w{a a} ).append( empty_stream ).to_a
      ).to eq(%w{a a})
    end
    it "an empty stream and a finite stream" do
      expect(
        empty_stream.append( finite_stream %w{a a} ).to_a
      ).to eq(%w{a a})
    end

    it "two empty streams" do
      expect( empty_stream.append empty_stream ).to be_empty
    end

    it "a finite stream and an infinite_stream" do
      expect(
        finite_stream( %w{b b} ).append( const_stream "c" ).take 3
      ).to eq( %w{b b c} )
    end

  end # context :append
end # describe Lab42::Stream

