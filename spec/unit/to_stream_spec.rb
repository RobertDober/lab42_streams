require 'spec_helper'

describe Lab42::Stream do 
  context :to_stream, :wip do
    context "from a stream" do 
      let(:ints){stream_by 0, :succ}
      it "returns itself" do
        expect( ints.to_stream ).to equal( ints )
      end
      it "returns itself on empty streams" do
        expect( empty_stream.to_stream ).to equal( empty_stream )
      end
    end # context "from a stream"
    
    context "from other objects" do 
      it "from arrays" do
        expect(
          %w{a b c}.to_stream.take 2
        ).to eq(%w{a b})
      end
      it "from enumerables" do
        expect(
          (1..9).to_stream.take 5
        ).to eq([*1..5])
      end
      it "from hashes" do
        expect(
          {a: 1, b: 2}.to_stream.take 5
        ).to eq([{a: 1}, {b: 2}])
      end
      it "from Enumerators" do
        expect(
          (1..5).to_enum.to_stream.take 5
        ).to eq([*1..5])
      end
      it "from Enumerators" do
        expect(
          (1..5).to_enum.to_stream.take 5
        ).to eq([*1..5])
      end
      it "from Lazy Enumerators" do
        expect(
          (1..5).lazy.to_stream.take 5
        ).to eq([*1..5])
      end
      
    end # context "from an Array"
  end # context :to_stream
end # describe Lab42::Stream
