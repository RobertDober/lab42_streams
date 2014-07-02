require 'spec_helper'

describe Lab42::Stream do 
  context 'each_without_loops' do 
    context 'empty' do 
      it 'does nothing' do
        expect( ->{ empty_stream.each_without_loops{ raise RuntimeError } } ).not_to raise_error
      end
    end # context 'empty'
    context 'no loops anywyay' do 
      it 'does not loop' do
        x = 0
        finite_stream( 1..2 ).each_without_loops{ |e| x += e }
        expect( x ).to eq 3
      end
    end # context 'no loops anywyay'
    context 'loops' do 
      it 'still does not loop' do
        x = []
        loop = cons_stream(1){ loop }
        loop.each_without_loops{ |e| x << e }
        expect( x ).to eq [1]
      end
    end # context 'loops'
  end # context 'each_without_loops'
end # describe Lab42::Stream
