require 'lab42/stream/empty'

module Lab42
  class Stream
    include Enumerable
    attr_reader :head, :promise

    def each
      yield head
      t = tail
      loop do
        yield t.head
        t = t.tail
      end
    end

    def tail
      promise.()
    end

    private
    def initialize h, t=nil, &tail
      @head    = h
      @promise = t || tail
    end
    
  end # class Stream
  module ::Kernel
    def cons_stream head, &tail
      Lab42::Stream.new head, tail
    end
  end # module ::Kernel
end # module Lab42
