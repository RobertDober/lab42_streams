
require_relative './stream/empty'
require_relative './stream/delayed'
require_relative './stream/kernel'
require_relative './stream/array'
require_relative './stream/enumerable'
require_relative './stream/hash'
require_relative './stream/proc'
require_relative './stream/class_methods'

# TODO: This should rather be implemented in lab_42/core/fn
require_relative './stream/kernel/extensions'

module Lab42
  class Stream
    extend ClassMethods

    ConstraintError = Class.new RuntimeError
    include Enumerable
    attr_reader :head, :promise

    def append other
      raise ArgumentError, "not a stream #{other}" unless self.class === other
      cons_stream( head ){ tail.append other }
    end
    alias_method :+, :append


    def combine_streams *args, &operation
      op = args.shift unless self.class === args.first
      raise ArgumentError, "Missing stream parameters" if args.empty?
      __combine_streams__ operation.make_behavior( op ), args
    end

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

    def inject_stream agg, *red, &reducer
      __inject__ agg, reducer.make_behavior( *red )
    end

    def filter *args, &blk
      filter_by_proc blk.make_behavior( *args )
    end

    def reject *args, &blk
      filter_by_proc blk.make_behavior( *args ).not
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
      transform_by_proc blk.make_behavior( *args )
    end

    def reduce_stream *red, &reducer
      __reduce__ reducer.make_behavior( *red )
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

    def __combine_streams__ op, args
      return empty_stream if args.any?(&sendmsg(:empty?))

      new_head = op.(head, *args.map(&sendmsg(:head)))
      cons_stream( new_head ){ tail.__combine_streams__(op, args.map(&sendmsg(:tail))) }
    end

    def __inject__ agg, a_proc
      new_agg = a_proc.(agg, head)
      cons_stream( new_agg ){ tail.__inject__ new_agg, a_proc }
    end

    def __flatmap__ a_proc
      hh = a_proc.( head )
      if hh.empty?
        tail.__flatmap__ a_proc
      else
        cons_stream( hh.head ){ hh.tail + tail.__flatmap__( a_proc ) }
      end
    end

    def __reduce__ a_proc
      tail.__inject__ head, a_proc
    end
    private
    def initialize h, t=nil, &tail
      @head    = h
      @promise = ( t || tail ).memoized
    end

    # def mk_proc args
    #   return args if Proc === args
    #   raise ArgumentError, "neither a Proc nor an array of args for Kernel#sendmsg" unless Array === args
    #   return args.first if Proc === args.first || Method === args.first
    #   sendmsg(*args)
    # end

  end # class Stream

end # module Lab42
