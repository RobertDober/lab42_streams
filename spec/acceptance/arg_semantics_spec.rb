require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  let( :n ){ 5 }
  let(:expected){[*0...n]}
  let(:verify){->(result){
    expect( result.take n ).to eq(expected)
  }}
  context 'function objects are recoginized' do
    it "by stream_by" do
      verify.( stream_by 0, 1.fn.+ )
    end
    it "by combine_streams" do
      ones = const_stream 1
      ints = cons_stream( 0 ){ 
        combine_streams ints, ones, Integer.fm.+ }
      verify.( ints )
    end
  end # context 'function objects are recoginized'
end # describe Lab42::Stream

