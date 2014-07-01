require 'spec_helper'
describe Lab42::Stream do
  context "cons_stream" do
    context "basic behavior" do 
      subject{ cons_stream(1){ empty_stream } }
      it "creates an appropriate object" do
        expect_subject.to be_kind_of( described_class )
      end
      context "which can be converted" do 
        it "to an array" do
          expect( subject.to_a ).to eq( [1] )
        end
      end # context "which can be converted"
    end # context "basic behavior"
  end 
end # describe Lab42::Stream
