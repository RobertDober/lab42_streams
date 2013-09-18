require 'spec_helper'

describe Lab42::Stream do 
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
end # describe Lab42::Stream
