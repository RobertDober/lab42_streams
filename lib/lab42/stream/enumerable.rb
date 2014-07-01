module Enumerable
  def to_stream; finite_stream self end
end

module Lab42
  class Stream
    module Enumerable

      def each
        t = self
        loop do
          yield t.head
          t = t.tail
        end
      end

      def reduce red, &reducer
        __reduce__ reducer.make_behavior( *red )
      end

      def inject agg, *red, &reducer
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

      def reduce_while cond, red=nil, &reducer
        red ||= reducer
        tail.__inject_while__ head, cond, red
      end

      def take n=1
        raise ArgumentError, "need a non negative Fixnum" if !(Fixnum === n) || n < 0
        x = []
        each do | ele |
          return x if n.zero?
          n -= 1
          x << ele
        end
        x
      end

      def take_while *bhv, &blk
        bhv = blk.make_behavior( *bhv )
        x = []
        each do | ele |
          return x unless bhv.( ele )
          x << ele
        end
        x
      end

      def to_a
        take_while :true
      end
      alias_method :entries, :to_a

      def __inject__ agg, a_proc
        new_agg = a_proc.(agg, head)
        cons_stream( new_agg ){ tail.__inject__ new_agg, a_proc }
      end
      def __reduce__ a_proc
        tail.__inject__ head, a_proc
      end
    end # module Enumerable
  end # class Stream
end # module Lab42
