module Lab42
  class Stream
    module HigherOrder
      def combine *streams_and_op, &operation
        op = streams_and_op.pop unless self.class === streams_and_op.last
        op = operation.make_behavior op
        # TODO: Decide what to do if op.arity and streams_and_op.size.succ do not match????
        __combine__( op, *streams_and_op )
      end

      def __combine__ op, *streams
        # TODO: Decide if we can continue if one of the streams is empty iff op.arity < 0
        #       for now no!
        return empty_stream if streams.any?( &:empty? )
        values = streams.map( &:head )
        new_head = op.(head, *values)
        cons_stream( new_head ){
          tail.__combine__( op, *streams.map( &:tail ) )
        }

      end
    end # module HigherOrder
    include HigherOrder
  end # class Stream
end # module Lab42
