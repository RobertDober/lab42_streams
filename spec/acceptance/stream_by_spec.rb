require 'spec_helper'

describe Lab42::Stream, :wip do
  context "stream_by" do 
  let(:integers){stream_by(0,:+,1)}
  it "defines the ints" do
    expect(integers.take 10).to eq([*0..9])
  end
    
  end # context "stream_by"
end # describe Lab42::Stream
