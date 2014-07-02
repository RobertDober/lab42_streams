require 'spec_helper'

describe Lab42::Stream do 
  context 'force_all' do
    context 'flat' do 
      subject do
        (1..3).to_stream
      end
      it "behaves like #entries" do
        expect( subject.force_all ).to eq( subject.entries )
      end
    end # context 'finite non recursive'

    context 'nested' do
      let(:a_stream){(2..2).to_stream}
      
      subject do
        finite_stream [ 1, a_stream, 3 ]
      end
      it 'expands nested streams' do
        expect( subject.force_all ).to eq( [ 1, [2], 3 ] )
      end
    end # context 'nested'

    context 'nested recursively' do

      it 'detects direct recursion' do
        r_stream = cons_stream(1){r_stream}
        expect( r_stream.force_all ).to eq [1]
      end

      it 'detects indirect recursion' do
        b_stream = nil
        a_stream = cons_stream(:a){ b_stream }
        b_stream = cons_stream(a_stream){ finite_stream [:b] }
        expect( a_stream.force_all ).to eq [ :a, [ :a, :b ], :b ]
        expect( b_stream.force_all ).to eq [ [ :a, :b ], :b ]
      end
      
      
    end # context 'nested recursively'
  end # context 'force_all'
end # describe Lab42::Stream
