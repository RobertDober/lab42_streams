require 'spec_helper'

RSpec.describe Lab42::Stream do
  let( :integers ){ iterate(0, :+, 1) }

  context :drop_while do
    it "works with blocks" do
      expect( integers.drop_while{ |x| x < 10 }.head ).to eq(10)
      expect( integers.drop_while{ false }.head ).to eq(0)
    end
    it "works with symbolic behavior" do
      expect( integers.drop_while(:<, 10).head ).to eq(10)
    end
    
  end

  context :drop_until do
    it "works with blocks" do
      expect( integers.drop_until{ |x| x >= 10 }.head ).to eq(10)
      expect( integers.drop_until{ true }.head ).to eq(0)
    end
    it "works with symbolic behavior" do
      expect( integers.drop_until(:>=, 10).head ).to eq(10)
    end

  end
end
