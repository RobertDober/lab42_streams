require 'lab42/core/kernel'
module Kernel
  def binop_streams op, stream1, stream2
    combine_streams stream1, stream2 do |e1, e2|
      e1.send op, e2
    end
  end

  def combine_streams s1, s2, &operation
    return empty_stream if s1.empty? || s2.empty?
    cons_stream operation.(s1.head, s2.head) do
      combine_streams( s1.tail, s2.tail, &operation)
    end
  end

  def cons_stream head, &tail
    Lab42::Stream.new head, tail
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

  def stream_by *args, &blk
    if blk
      cons_stream(*args){ stream_by( blk.(*args), &blk ) }
    else
      rest = args.drop 1
      cons_stream( args.first ){ stream_by( sendmsg(*rest).(args.first), *rest ) }
    end
  end
end
