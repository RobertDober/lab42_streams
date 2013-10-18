require 'lab42/stream/empty'
require 'lab42/stream/delayed'
require 'lab42/stream/kernel'
require 'lab42/stream/array'
require 'lab42/stream/enumerable'
require 'lab42/stream/hash'
require 'lab42/stream/proc'

module Lab42
  class Stream
    ConstraintError = Class.new RuntimeError
    include Enumerable
    attr_reader :head, :promise

    def append other
      raise ArgumentError, "not a stream #{other}" unless self.class === other
      cons_stream( head ){ tail.append other }
    end
    alias_method :+, :append

    def drop n = 1
      raise ArgumentError, "not a non negative number" if n < 0
      t = self
      loop do
        return t if n.zero?
        n -=1
        t = t.tail
      end
    end

    def each
      t = self
      loop do
        yield t.head
        t = t.tail
      end
    end

    def empty?; false end

    def filter *args, &blk
      # TODO: Get this check and a factory to create a proc for this into core
      raise ArgumentError, "use either a block or arguments" if args.empty? && !blk || !args.empty? && blk
      filter_by_proc mk_proc( blk || args )
    end

    def filter_by_proc prc
      if prc.(head)
        cons_stream(head){ tail.filter_by_proc prc }
      else
        # TODO: Replace this with Delayed Stream (1 off)
        tail.filter_by_proc prc 
      end
    end

    def flatmap *args, &blk
      if args.empty?
        __flatmap__ blk
      elsif args.size == 1 && args.first.respond_to?( :call )
        __flatmap__ args.first
      else
        __flatmap__ sendmsg(*args)
      end
    end

    def __inject_while__ ival, cond, red
      raise ConstraintError unless cond.(ival)
      s = self
      loop do
        new_val = red.(ival, s.head)
        return ival unless cond.(new_val)
        ival = new_val
        s = s.tail
        return ival if s.empty?
      end
    end

    def make_cyclic
      cons_stream( head ){
        tail.append( make_cyclic )
      }
    end

    def map *args, &blk
      # TODO: Get this check and a factory to create a proc for this into core/fn
      raise ArgumentError, "use either a block or arguments" if args.empty? && !blk || !args.empty? && blk
      transform_by_proc mk_proc( blk || args )
    end

    def reduce_while cond, red=nil, &reducer
      red ||= reducer
      tail.__inject_while__ head, cond, red
    end

    def tail
      promise.()
    end

    def to_stream; self end

    def transform_by_proc prc
      cons_stream( prc.(head) ){ tail.transform_by_proc prc }
    end

    def __flatmap__ a_proc
      hh = a_proc.( head )
      if hh.empty?
        tail.__flatmap__ a_proc
      else
        cons_stream( hh.head ){ hh.tail + tail.__flatmap__( a_proc ) }
      end
    end

    private
    def initialize h, t=nil, &tail
        @head    = h
        @promise = ( t || tail ).memoized
    end

    # TODO: Use this from core/fn as soon as available
    def mk_proc args
      return args if Proc === args
      raise ArgumentError, "neither a Proc nor an array of args for Kernel#sendmsg" unless Array === args
      return args.first if Proc === args.first || Method === args.first
      sendmsg(*args)
    end

  end # class Stream

end # module Lab42
