require 'lab42/stream/empty'
require 'lab42/stream/kernel'
require 'lab42/stream/proc'

module Lab42
  class Stream
    include Enumerable
    attr_reader :head, :promise

    def append other
      raise ArgumentError, "not a stream #{other}" unless self.class === other
      cons_stream( head ){ tail.append other }
    end
    def drop n = 1
      raise ArgumentError, "not a non negative number" if n < 0
      t = self
      loop do
        return t if n.zero?
        n -=1
        t = t.tail
      end
    end

    def each
      t = self
      loop do
        yield t.head
        t = t.tail
      end
    end

    def empty?; false end

    def make_cyclic
      cons_stream( head ){
        tail.append( make_cyclic )
      }
    end

    def tail
      promise.()
    end

    def to_stream; self end

    private
    def initialize h, t=nil, &tail
      @head    = h
      @promise = ( t || tail ).memoized
    end
    
  end # class Stream

end # module Lab42
