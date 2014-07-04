module Enumerable
  def to_stream; finite_stream self end
end

module Lab42
  class Stream
    module Enumerable

      def drop_until *bhv, &blk
        bhv = blk.make_behavior( *bhv )
        s = self
        loop do
          return s if bhv.(s.head)
          s = s.tail
        end
        empty_stream
      end

      # N.B. Not implemented as drop_until( bhv.not )
      # for performance reasons
      def drop_while *bhv, &blk
        bhv = blk.make_behavior( *bhv )
        s = self
        loop do
          return s unless bhv.(s.head)
          s = s.tail
        end
        empty_stream
      end

      def each
        t = self
        loop do
          yield t.head
          t = t.tail
        end
      end

      def each_without_loops
        visited = {}
        t = self
        loop do
          h = t.head
          yield h
          visited[ t.object_id ] = true
          t = t.tail
          return if visited[t.object_id]
        end
      end

      def force_all cache={}
        x = []
        each_without_loops do | ele |
          if self.class === ele
            if ! cache[ele.object_id]
              cache[ele.object_id] = true
              x << ele.force_all( cache )
            end
          else
            x << ele
          end
        end
        x
      end

      def reduce red=nil, &reducer
        red = reducer.make_behavior( red )
        tail.__inject__ head, red
      end

      def inject agg, *red, &reducer
        __inject__ agg, reducer.make_behavior( *red )
      end

      def filter *args, &blk
        __filter__ blk.make_behavior( *args )
      end

      def reject *args, &blk
        __filter__ blk.make_behavior( *args ).not
      end

      def flatmap *args, &blk
        __flatmap__ blk.make_behavior( *args )
      end

      def __flatmap__ a_proc
        # require 'pry'
        # binding.pry
        hh = a_proc.( head )
        if hh.empty?
          tail.__flatmap__ a_proc
        else
          cons_stream( hh.head ){ hh.tail + tail.__flatmap__( a_proc ) }
        end
      end

      def flatmap_with_each *args, &blk
        __flatmap_with_each__ blk.make_behavior( *args )
      end

      def __flatmap_with_each__ a_proc, rest_of_enum = []
        # Process expanded values
        return cons_stream( rest_of_enum.first ){ __flatmap_with_each__ a_proc, rest_of_enum.drop( 1 ) } unless
          rest_of_enum.empty?

        # Map a scalar value
        hh = a_proc.( head )
        return cons_stream( hh ){ tail.__flatmap_with_each__ a_proc } unless
          hh.respond_to? :each

        # Start a new expansion...
        # ... consider an empty expansion
        return tail.__flatmap__ a_proc if hh.empty?
        # ... expand values
        cons_stream( hh.first ){ tail.__flatmap_with_each__( a_proc, hh.drop( 1 ) ) }
      end


      def take_until *bhv, &blk
        bhv = blk.make_behavior( *bhv )
        x = []
        each do | ele |
          return x if bhv.( ele )
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

      def make_cyclic
        cons_stream( head ){
          tail.append( make_cyclic )
        }
      end

      def map *args, &blk
        # TODO: Get this check and a factory to create a proc for this into core/fn
        raise ArgumentError, "use either a block or arguments" if args.empty? && !blk || !args.empty? && blk
        __map__ blk.make_behavior( *args )
      end

      def __map__ prc
        cons_stream( prc.(head) ){ tail.__map__ prc }
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


      def __filter__ a_proc
        if a_proc.( head )
          cons_stream( head ){ tail.__filter__ a_proc } 
        else
          tail.__filter__ a_proc
        end
      end

      def __inject__ agg, a_proc
        new_agg = a_proc.(agg, head)
        tail.__inject__ new_agg, a_proc
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

      def __scan__ agg, a_proc
        new_agg = a_proc.(agg, head)
        cons_stream( new_agg ){ tail.__inject__ new_agg, a_proc }
      end

    end # module Enumerable
  end # class Stream
end # module Lab42
