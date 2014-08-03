require 'spec_helper'
require 'ostruct'
require 'lab42/core/enumerable'

describe Enumerable do 
 
  subject do
    [
      OpenStruct.new( name: 'vil', age: 10 ),
      OpenStruct.new( name: 'rob', age: 42 ),
      OpenStruct.new( name: 'ang', age:  8 ),
    ]
  end

  context 'ordered_by' do
    it 'can be ordered by block' do
      expect( subject.ordered_by{|a,b| a.age > b.age }.map(&:name) ).to eq %W{ rob vil ang }
    end
    it 'can be ordered by a symbol' do
      expect( (1..3).ordered_by :> ).to eq [3,2,1]
    end
  end # context 'ordered_by'
end # describe Enumerable
