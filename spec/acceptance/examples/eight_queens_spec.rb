require 'spec_helper'

class Array
  # A position is an array of color positions for each row and the size of the board
  # the following position
  #
  #       +---+---+---+---+
  #       |   | Q |   |   |
  #       +---+---+---+---+
  #       |   |   |   | Q |
  #       +---+---+---+---+
  #       |   |   |   |   |
  #       +---+---+---+---+
  #       |   |   |   |   |
  #       +---+---+---+---+
  #
  #  is therefore represented as size:4, positions [1, 3]
  #
  def legal?
    each_with_index.all?{ |e,i| !drop(i.succ).each_with_index.any?{ |f,j| e==f || (f-e).abs == (j+1) }}
  end
end

def expand pos, size
  finite_stream(0...size)
  .map{ |i|
    pos + [i]
  }
  .filter( :legal? )
end
def fill k, size
  return finite_stream [[]] if k.zero?
  fill( k-1, size )
  .flatmap do |pos|
    expand(pos, size)
  end
end
def queens size
  fill size, size
end

describe Lab42::Stream do
  context "N Queens", :wip do
    context 'the 3 queens problem' do 
      it 'has no solution' do
        expect( queens(3) ).to be_empty
      end
    end # context 'no solution for the 4 queens problem'

    context 'the 4 queens problem' do 

      context 'initial position' do
        subject do
          fill 0, 4
        end
        it 'can create an initial board' do
          expect( subject.head ).to eq []
        end
        it 'has only position' do
          expect( subject.tail ).to be_empty
        end
      end # context 'initial position'

      context 'first row' do
        subject do
          fill( 1, 4 ).to_a
        end
        it 'shall have four positions (one for the queen of the first row positioned on one of the four columns)' do
          expect( subject ).to eq [[0], [1], [2], [3]]
        end
      end # context 'first row'

      context 'first two rows', :wip do
        subject do
          fill( 2, 4 ).to_a
        end
        it 'has 6 legal positions' do
          expect( subject ).to eq [
            [0,2], [0,3],
            [1,3],
            [2,0],
            [3,0], [3,1]
          ]
        end
      end # context 'first row'
      context 'has solutions' do 
        subject do
          queens 4
        end
        it 'of the number two' do
          expect( subject.to_a ).to eq [[1, 3, 0, 2], [2, 0, 3, 1]]
        end
      end # context 'solutions'
    end # context 'the 4 queens problem'

    context 'the 8 queens problem' do 
      subject do
        queens 8
      end
      it 'has 92 solutions', :slow do
        expect( subject.to_a.size ).to eq 92
      end
      it 'of which the first is' do
        expect( subject.head ).to eq [0, 4, 7, 5, 2, 6, 1, 3]
      end
    end # context 'the 8 queens problem'

  end # context "8-Queens"
end # describsLab42::Stream
