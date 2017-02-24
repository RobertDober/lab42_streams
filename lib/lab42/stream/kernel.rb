require 'lab42/core/kernel'
require_relative 'behavior'

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
    case enum
    when Range
      _finite_stream_from_range enum
    when Array
      _finite_stream_from_ary enum
    when Hash
      _finite_stream_from_hash enum
    when Enumerator
      _finite_stream_from_enumerator! enum.to_enum
    else
      raise TypeError, "cannot create a finite stream from type #{enum.class.inspect}"
    end
  end

  def flatmap stream, *args, &blk
    stream.flatmap( *args, &blk )
  end

  def merge_streams *streams
    s = streams.reject( &:empty? )
    return empty_stream if s.empty?
    cons_stream s.first.head do
      merge_streams(*(s.drop(1) + [s.first.tail]))
    end
  end

  def merge_streams_by *streams_and_beh, &blk
    beh = Lab42::Stream::Behavior.make1( blk || streams_and_beh.pop, &blk )
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
    if rest.first && rest.first.respond_to?( :call )
      cons_stream( args.first ){ iterate( rest.first.(*([args.first] + rest.drop(1))), *rest ) }
    else
      cons_stream( args.first ){ iterate( args.first.send(*rest), *rest ) }
    end
  end

  private

  def _finite_stream_from_ary ary
      return empty_stream if ary.empty?
      cons_stream(ary.first){ finite_stream(ary.drop(1)) }
  end

  def _finite_stream_from_boundaies fst, lst
    return empty_stream if fst > lst 
    cons_stream(fst){ _finite_stream_from_boundaies fst.succ, lst }
  end
  
  def _finite_stream_from_hash hsh
      return empty_stream if hsh.empty?
      cons_stream(hsh.first){ finite_stream(hsh.without(hsh.first.first)) }
  end

  def _finite_stream_from_enumerator! enum
    cons_stream( enum.next ){ _finite_stream_from_enumerator! enum }
  rescue StopIteration
    empty_stream
  end

  def _finite_stream_from_range range
    fst = range.first
    lst = range.last
    lst = lst.pred if range.exclude_end?
    _finite_stream_from_boundaies fst, lst
  end

  def __merge_streams_by__ beh, streams
    still_there = streams.reject( &:empty? )
    return empty_stream if still_there.empty?
    __merge_streams_by_with_present__ beh, still_there
  end 

  def __merge_streams_by_with_present__ beh, still_there
    ordered_heads = still_there
    .map( &:head )
    .ordered_by( beh )

    cons_stream_n( *ordered_heads ){
      __merge_streams_by__ beh, still_there.map( &:tail )
    }
  end
end
