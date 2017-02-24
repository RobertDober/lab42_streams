require 'spec_helper'

RSpec.describe Lab42::Stream do
  context "enumerator isolation" do
    let( :enumerator ){ (1..3).to_enum }
    let( :stream1 ){ finite_stream(enumerator) }
    let( :stream2 ){ finite_stream(enumerator) }

    it "allows to advance one stream without advancing the other" do
      expect( stream1.take(2) ).to eq [1, 2]
      expect( stream2.take(1) ).to eq [1]
    end
  end
end
