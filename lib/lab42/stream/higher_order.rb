require_relative 'behavior'
module Lab42
  class Stream
    module HigherOrder
      def combine *streams_and_op, &operation
        op = streams_and_op.pop unless self.class === streams_and_op.last
        op = Behavior.make1( op, &operation )
        __combine__( op, *streams_and_op )
      end

      def __combine__ op, *streams
        return empty_stream if streams.any?( &:empty? )
        values = streams.map( &:head )
        new_head = op.(head, *values)
        cons_stream( new_head ){
          tail.__combine__( op, *streams.map( &:tail ) )
        }
      end

      def split_into n
        indexed = with_index
        n.times.map do | i |
          indexed
            .filter{ |_, idx| idx % n == i }
            .map( :first )
        end
      end
    end # module HigherOrder
    include HigherOrder
  end # class Stream
end # module Lab42
