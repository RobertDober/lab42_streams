require 'spec_helper'

describe Lab42::Stream do
  context "finite streams" do 
    let :s1 do
      finite_stream 1..3
    end
    let :s2 do
      finite_stream [1,1]
    end
    it "zips (cutting the longer)" do
      expect(
        combine_streams(s1,s2){|a,b| [a,b]}.to_a
      ).to eq([[1,1],[2,1]])
    end
  end # context "finite streams"

  context "infinite streams" do
    def ints from=0
      cons_stream( from ){ ints from.succ }
    end
    let(:squares){ combine_streams ints, ints, :*}
    
    it 'generates the square of ints' do
      expect( squares.take 5 ).to eq([0, 1, 4, 9, 16])
    end

    context "many streams" do 
      let(:adder){ ->(*a){ a.inject 0, :+ } }
      
      it "can multiply a stream by three" do
        expect( combine_streams( ints, ints, ints, adder ).take 3 ).to eq [0, 3, 6]
      end
    end # context "many streams"
  end # context "infinite streams"

end # describe Lab42::Stream
