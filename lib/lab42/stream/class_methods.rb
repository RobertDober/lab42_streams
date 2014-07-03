module Lab42
  class Stream
    module ClassMethods
      def iterate arg, beh=nil, &blk
        beh = blk.make_behavior beh
        __iterate__ arg, beh
      end

      private
      def __iterate__ arg, beh
        cons_stream arg do
          __iterate__ beh.( arg ), beh
        end
      end
    end # module ClassMethods
  end # class Stream
end # module Lab42
