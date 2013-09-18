require 'spec_helper'

describe Lab42::Stream do 
  context :const_stream do 
    subject{ const_stream 1 }
    it "is infinite" do
      expect(
        subject.tail
      ).to eq( subject )
    end

    it "is correct" do
      expect(
        subject.head
      ).to eq( 1 )
    end
  end # context :const_stream
end # describe Lab42::Stream
