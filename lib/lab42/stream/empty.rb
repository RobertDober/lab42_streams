module Lab42
  class Stream
    class Empty < Stream
      def empty?; true end
      # I believe that this definition is sound, although it is an obvious pitfall
      # But falling into it once, means understanding streams better, well that is
      # my opinion now, we will see what promises the future will bring...
      def tail; self end
      def head; raise StopIteration, "head called on empty stream" end

      private
      def initialize; end

      def self.new
        @__instance__ ||= allocate
      end
    end # class Empty

    module ::Kernel
      def empty_stream; Empty.new end
    end # module ::Kernel
  end # class Stream
end # module Lab42
