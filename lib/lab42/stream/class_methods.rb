module Lab42
  class Stream
    module ClassMethods
      def iterate init, bhv=nil, &blk
        __iterate__ init, blk.make_behavior( bhv )
      end

      private
      def __iterate__ arg, bhv
        cons_stream arg do
          __iterate__ bhv.( arg ), bhv
        end
      end
    end # module ClassMethods
  end # class Stream
end # module Lab42
