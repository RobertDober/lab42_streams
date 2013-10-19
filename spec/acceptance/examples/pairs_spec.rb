require 'spec_helper'

describe Lab42::Stream do
  let(:ints_from){
    -> (n) {
    cons_stream( n ){ binop_streams :+, const_stream(1), ints_from.(n) }
  }
  }
  let(:pairs_from){
    -> (n) {
    cons_stream( [n,n] ){
      merge_streams( ints_from.(n.succ).map{|i| [n,i]},
                    pairs_from.(n.succ)) }
  }
  }

  it "has a sound definition" do
    expect( ints_from.(1).take 5 ).to eq([*1..5])
  end
  it "generates pairs" do
    expect( pairs_from.(0).take 9 ).to eq([[0,0],[0,1],[1,1],[0,2],[1,2],[0,3],[2,2],[0,4],[1,3]])
  end
end # describe Lab42::Stream
