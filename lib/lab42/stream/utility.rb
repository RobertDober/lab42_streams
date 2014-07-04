module Lab42
  class Stream
    module Utility
      def split_by_value value, exclude: false
        if head == value
          next_stream = tail.lazy_take_until{ |e| e == value }
          if !exclude
            head_stream = cons_stream(head){ next_stream }
          else
            head_stream = next_stream
          end
          cons_stream( head_stream ){
            tail.drop_until{ |e| e == value }.split_by_value value, exclude: exclude
          }
        else
          cons_stream( lazy_take_until{ |e| e == value } ){
            drop_until{ |e| e == value }.split_by_value value
          }
        end
      end
    end # module Utility
    include Utility
  end # class Stream
end # module Lab42
