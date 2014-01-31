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

  context "infinite streams", :wip do
    def ints
      cons_stream( 1 ){ combine_stream( ints, ints.tail, :+ ) }
    end
    it 'generates the ints' do
      expect( ints.take 5 ).to eq([*2..6])
    end
    
  end # context "infinite streams"
end # describe Lab42::Stream
