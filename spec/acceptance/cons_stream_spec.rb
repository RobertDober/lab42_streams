require 'spec_helper'
describe Lab42::Stream, :wip do
  context "cons_stream" do
    context "basic behavior" do 
      subject{ cons_stream(1){ empty_stream } }
      it "creates an appropriate object" do
        expect( subject ).to be_kind_of( described_class )
      end
    end # context "basic behavior"
  end 
end # describe Lab42::Stream
