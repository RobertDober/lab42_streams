require 'spec_helper'

describe Lab42::Stream do 
  context "zip", :wip do
    let( :ints ){ iterate 0, :succ }
    let( :digits ){ finite_stream 0..9 }
    

    context "empty" do 
      it 'will remain empty' do
        expect( empty_stream.zip empty_stream ).to be_empty
        expect( empty_stream.zip ints ).to be_empty
        expect( empty_stream.zip digits ).to be_empty
      end
    end # context "empty"

    
    context "finite" do 
      it 'is ok with at least as long streams' do
        expect( digits.zip( digits ).entries.map(&:entries) ).to eq [
          [0,0], [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9]
        ]
      end
      it 'is ok with longer streams' do
        expect( digits.zip( (0..10).to_stream ).entries.map(&:entries) ).to eq [
          [0,0], [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9]
        ]
      end
      it 'is ok with infinite streams' do
        expect( digits.zip( ints ).entries.map(&:entries) ).to eq [
          [0,0], [1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9]
        ]
      end
      it 'can take more than one arg' do
        expect( digits.zip( ints, digits ).map(&:entries).take 3 ).to eq [
          [0,0,0], [1,1,1], [2,2,2]
        ]
      end
    end # context "finite"

    context "infinite" do 
      it 'is ok with other infinites' do
        expect( ints.zip( ints ).map(&:entries).drop(100).take 5 ).to eq [
          [100,100], [101,101], [102,102], [103,103], [104, 104]
        ]
      end
    end # context "infinite"
  end # context "zip"

  
end # describe Lab42::Stream
