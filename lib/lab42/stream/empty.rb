module Lab42
  class Stream
    class Empty < Stream
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
  end # class Stream
end # module Lab42
