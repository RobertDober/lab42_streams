require_relative 'core/enumerable'
require_relative 'behavior'

module Lab42
  class Stream
    IllegalState = Class.new RuntimeError

    module Enumerable

      def drop_until *bhv, &blk
        bhv = Behavior.make( *bhv, &blk )
        __drop_while__ bhv.not
      end

      def drop_while *bhv, &blk
        bhv = Behavior.make( *bhv, &blk )
        __drop_while__ bhv
      end


      def __drop_while__ bhv
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
          return if t.empty?
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

      def lazy_take n=1
        raise ArgumentError, "need a non negative Integer" if !(Integer === n) || n < 0
        __lazy_take__ n
      end

      def __lazy_take__ n
        return empty_stream if n.zero?
        cons_stream( head ){ tail.__lazy_take__ n.pred }
      end

      def lazy_take_until *bhv, &blk
        bhv = Behavior.make( *bhv, &blk )
        __lazy_take_until__ bhv
      end

      def __lazy_take_until__ bhv
        return empty_stream if bhv.(head)
        cons_stream( head ){
          tail.__lazy_take_until__ bhv
        }
      end

      def lazy_take_while *bhv, &blk
        bhv = Behavior.make( *bhv, &blk )
        __lazy_take_while__ bhv
      end

      def __lazy_take_while__ bhv
        return empty_stream unless bhv.(head)
        cons_stream( head ){
          tail.__lazy_take_while__ bhv
        }
      end

      def reduce red=nil, &reducer
        red = Behavior.make( red, &reducer)
        tail.__inject__ head, red
      end

      def inject agg, *red, &reducer
        __inject__ agg, Behavior.make( *red, &reducer )
      end

      def filter *args, &blk
        __filter__ self, Behavior.make( *args, &blk )
      end

      def reject *args, &blk
        __filter__ self, Behavior.make( *args, &blk ).not
      end

      def flatmap *args, &blk
        __flatmap__ Behavior.make( *args, &blk )
      end

      def __flatmap__ a_proc
        hh = a_proc.( head )
        raise ArgumentError, "flatmap can only map on streams, use flatmap_with_each to map over streams and enumerables" unless
          Lab42::Stream === hh
        if hh.empty?
          tail.__flatmap__ a_proc
        else
          cons_stream( hh.head ){ hh.tail + tail.__flatmap__( a_proc ) }
        end
      end

      def flatmap_with_each *args, &blk
        __flatmap_with_each__ Behavior.make( *args, &blk )
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


      def scan initial, *args, &blk
        cons_stream initial do
          __scan__ initial, Behavior.make( *args, &blk )
        end.tap{ |r|
        }
      end

      def scan1 *args, &blk
        tail.scan( head, *args, &blk )
      end

      def __scan__ initial, beh
        h = beh.(initial, head)
        cons_stream( h ){ tail.__scan__ h, beh }
      end

      def take_until *bhv, &blk
        bhv = Behavior.make( *bhv, &blk )
        __take_while__ bhv.not
      end

      def take_while *bhv, &blk
        bhv = Behavior.make( *bhv, &blk )
        __take_while__ bhv
      end

      def __take_while__ bhv
        x = []
        each do | ele |
          return x unless bhv.( ele )
          x << ele
        end
        x
      end

      def to_a
        take_while Behavior.const( true ) 
      end

      alias_method :entries, :to_a

      def make_cyclic
        cons_stream( head ){
          tail.append( make_cyclic )
        }
      end

      def map *args, &blk
        raise ArgumentError, "use either a block or arguments" if args.empty? && !blk || !args.empty? && blk
        __map__ Behavior.make( *args, &blk )
      end

      def __map__ prc
        cons_stream( prc.(head) ){ tail.__map__ prc }
      end


      def reduce_while cond, red=nil, &reducer
        red ||= reducer
        tail.__inject_while__ head, cond, red
      end

      def take n=1
        raise ArgumentError, "need a non negative Integer" if !(Integer === n) || n < 0
        x = []
        each do | ele |
          return x if n.zero?
          n -= 1
          x << ele
        end
        x
      end

      def zip *other_streamables
        streams = other_streamables.map{ |s|
          self.class === s ? s : s.to_stream
        }
        __zip__ streams
      end

      def zip_as_ary *other_streamables
        zip( *other_streamables )
        .map( &:entries )
      end

      def __zip__ streams
        cons_stream( [head] + streams.map(&:head) ){
          tail.__zip__ streams.map(&:tail)
        }
      end

      def __filter__ stream, a_proc
        loop do
          return stream if stream.empty?
          return cons_stream( stream.head ){ __filter__ stream.tail, a_proc } if a_proc.( stream.head )
          stream = stream.tail
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
    end # module Enumerable
    include Enumerable
  end # class Stream
end # module Lab42
