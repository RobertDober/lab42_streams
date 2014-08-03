module Enumerable
  def ordered_by *beh, &blk
    raise ArgumentError, 'need exactly one of block and behavior' if !blk == beh.empty?
    
    beh = blk || (Symbol === beh.first ? sendmsg( *beh ) : beh.first )

    
    sort do | a, b |
      a == b ? 0 : (
        beh.(a, b) ? -1 : 1
    )
    end
  end

  def to_stream; finite_stream self end
end

