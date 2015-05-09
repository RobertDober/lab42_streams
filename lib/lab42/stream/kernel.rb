require 'lab42/core/kernel'
module Kernel
  def binop_streams op, stream1, stream2
    combine_streams stream1, stream2 do |e1, e2|
      e1.send op, e2
    end
  end

  def combine_streams stream, *streams_and_ops, &operation
    stream.combine( *streams_and_ops, &operation )
  end

  def cons_stream head, &tail
    Lab42::Stream.new head, tail
  end

  def cons_stream_n first_head, *more_heads, &tail
    return cons_stream( first_head, &tail ) if more_heads.empty?
    return cons_stream( first_head ){
      cons_stream_n( *more_heads, &tail )
    }
  end

  def const_stream const
    c = cons_stream( const ){ c }
  end

  def cyclic_stream *args
    args = args.first if
    args.size == 1 && Enumerable === args.first

    finite_stream( args ).make_cyclic
  end

  def finite_stream enum
    e = enum.lazy
    cons_stream( e.peek ){ finite_stream e.drop( 1 ) }
  rescue StopIteration
    empty_stream
  end

  def flatmap stream, *args, &blk
    stream.flatmap( *args, &blk )
  end

  # TODO: Reimplement with a cursor into streams to avoid
  # the (potentially) costly array arithm in the tail def
  def merge_streams *streams
    s = streams.reject( &:empty? )
    return empty_stream if s.empty?
    cons_stream s.first.head do
      merge_streams(*(s.drop(1) + [s.first.tail]))
    end
  end

  def merge_streams_by *streams_and_beh, &blk
    beh = blk || streams_and_beh.pop
    __merge_streams_by__ beh, streams_and_beh
  end

  def iterate *args, &blk
    if blk
      cons_stream(*args){ iterate( blk.(*args), &blk ) }
    else
      iterate_without_block args
    end
  end
  alias_method :stream_by, :iterate

  def iterate_without_block args
    rest = args.drop 1
    if Method === rest.first 
      cons_stream( args.first ){ iterate( rest.first.(*([args.first] + rest.drop(1))), *rest ) }
    else
      cons_stream( args.first ){ iterate( sendmsg(*rest).(args.first), *rest ) }
    end
  end

private
def __merge_streams_by__ beh, streams
  still_there = streams.reject( &:empty? )
  return empty_stream if still_there.empty?
  __merge_streams_by_with_present__ beh, still_there, streams
end 

def __merge_streams_by_with_present__ beh, still_there, streams
  ordered_heads = still_there
  .map( &:head )
  .ordered_by( beh )

  cons_stream_n( *ordered_heads ){
    __merge_streams_by__ beh, still_there.map( &:tail )
  }
end
end
