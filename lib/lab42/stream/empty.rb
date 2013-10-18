module Lab42
  class Stream
    class Empty < Stream
      # TODO: Implement all self returning methods with Forwarder
      def append other
        raise ArgumentError, "not a stream #{other}" unless self.class.superclass === other
        # ??? Is the to_stream message a good idea
        other.to_stream
      end
      alias_method :+, :append

      def empty?; true end

      def filter *args, &blk; self end

      def head; raise StopIteration, "head called on empty stream" end

      def make_cyclic; self end
      def map *args, &blk; self end
      # I believe that this definition is sound, although it is an obvious pitfall
      # But falling into it once, means understanding streams better, well that is
      # my opinion now, we will see what promises the future will bring...
      def tail; self end


      def flatmap *args, &blk; self end
      def __flatmap__ a_proc; self end

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
