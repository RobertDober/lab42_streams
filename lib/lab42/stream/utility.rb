module Lab42
  class Stream
    module Utility

      def segment *args, &blk
        __segment__ Behavior.make( *args, &blk )
      end

      def __segment__ beh
        if beh.( head )
          cons_stream( cons_stream( head ){  tail.lazy_take_until beh } ){
            tail.drop_until( beh ).__segment__ beh
          }
        else
          cons_stream( lazy_take_until beh ){
            tail.drop_until( beh ).__segment__ beh
          }
        end
      end

      def with_index  start={}
        start = Hash === start ? start.fetch( :from, 0 ) : start
        zip_as_ary iterate( start, :succ )
      end
    end # module Utility
    include Utility
  end # class Stream
end # module Lab42
