require 'spec_helper'

describe Lab42::Stream do 
  context 'combine' do 

    let(:ints){iterate 0, :succ}
    let(:ones){const_stream 1}
    let(:digits){finite_stream 0..9}

    let( :adder ){
      -> *args do
        args.inject 0, :+
      end
    }
    

    context 'needs a stream param' do 
      it{ expect{ digits.combine_streams }.to raise_error(ArgumentError, %r{\AMissing stream parameters}) }
    end

    context 'empty' do 
      it 'combined with empty is empty' do
        expect( empty_stream.combine empty_stream, :no_such_method ).to be_empty
      end
      it 'remains empty if combined with any stream' do
        expect( empty_stream.combine( ints ){ raise RuntimeError } ).to be_empty
      end
    end # context 'empty'

    context 'finite' do 
      let(:shorter){digits.lazy_take_while :<, 5}
      
      it 'combine two streams of same length' do
        expect( digits.combine( digits, :+ ).entries ).to eq [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
      end
      it 'combine three streams of same length' do
        expect( digits.combine( digits, digits, adder ).drop.take 5 ).to eq [3, 6, 9, 12, 15]
      end
      it 'combine with shorter stream' do
        expect( 
             digits.combine( shorter, :+ ).entries
              ).to eq [0, 2, 4, 6, 8]
      end
      it 'combine with longer stream' do
        expect( 
             shorter.combine( digits, :+ ).entries
              ).to eq [0, 2, 4, 6, 8]
      end
    end # context 'finite'

    context 'inifinite' do 
      it 'combine two' do
        incremented = ones.combine ints, :+
        expect( incremented.drop.take 5 ).to eq [*2..6]
      end
      it 'combine more' do
        incremented = ones.combine ints, ones, adder
        expect( incremented.drop.take 5 ).to eq [*3..7]
      end
      
    end # context 'inifinite'

    context 'mixed' do 
      it 'combine infinite with empty' do
        expect( ints.combine empty_stream, :no_such_method ).to be_empty
      end
      it 'combine infinite with finite' do
        expect( ones.combine( digits, ints, adder ).entries ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
      end
      it 'combine finite with infinite' do
        expect( digits.combine( digits, ones, adder ).entries ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
        expect( digits.combine( ones, digits, adder ).entries ).to eq [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
      end
    end # context 'mixed'
  end # context 'combine'
end # describe Lab42::Stream
