require 'spec_helper'

N = 5
describe Lab42::Stream do 
  let(:expected){[*0...N]}
  let(:verify){->(result){
    expect( result.take N ).to eq(expected)
  }}
  context 'function objects are recoginized', :wip do
    it "by stream_by" do
      verify.( stream_by 0, 1.fn.+ )
    end
    it "by combine_streams" do
      ones = const_stream 1
      ints = cons_stream( 0 ){ 
        combine_streams ints, ones, Fixnum.fm.+ }
      verify.( ints )
    end
  end # context 'function objects are recoginized'
end # describe Lab42::Stream
