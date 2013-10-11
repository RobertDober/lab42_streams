module Lab42
  class Stream
    class Delayed < Stream
      def head; tail.head end
      def tail; super.tail end
    end # class Delayed
  end # class Stream
end # module Lab42
