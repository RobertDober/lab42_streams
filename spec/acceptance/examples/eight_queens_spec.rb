require 'spec_helper'

class Array
 def legal?; 
   each_with_index.all?{ |e,i| !drop(i.succ).each_with_index.any?{ |f,j| e==f || (f-e).abs == (j+1) }}
 end
end

def expand pos, size
  finite_stream(0...size)
    .map{ |i|
      pos + [i]
    }
    .filter :legal?
end
def fill k, size
  return finite_stream [[]] if k.zero?
  fill( k-1, size ).flatmap{ |pos| expand( pos, size ) }
end
def queens size
  fill size, size
end

describe Lab42::Stream do

  it "finds first solution" do
    expect(
      queens(5).head
    ).to eq( [0,2,4,1,3] )
  end

end # describe Lab42::Stream
