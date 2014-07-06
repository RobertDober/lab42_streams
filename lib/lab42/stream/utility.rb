module Lab42
  class Stream
    module Utility

      def segment *args, &blk
        __segment__ blk.make_behavior( *args )
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
    end # module Utility
    include Utility
  end # class Stream
end # module Lab42
