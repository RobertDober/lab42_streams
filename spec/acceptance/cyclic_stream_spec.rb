require 'spec_helper'

describe Lab42::Stream do
  context :cyclic_stream do 
    context :empty do
      it "is empty" do
        expect( cyclic_stream ).to be_empty
      end
    end # context :empty
  end # context :cyclic_stream
end # describe Lab42::Stream

