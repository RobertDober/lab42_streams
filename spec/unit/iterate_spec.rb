require 'spec_helper'

describe Lab42::Stream do

  context '.iterate' do 
    subject do
      described_class.iterate 0, :succ
    end
    
    it "is a stream" do
      expect( subject ).to be_kind_of described_class
    end

    it "just about behves as we should expect" do
      expect( subject.drop(20).take(5) ).to eq( (20..24).to_a )
    end
  end # context '.iterate'
  
  
end # describe 'Stream.iterate'
