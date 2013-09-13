require 'lab42/stream/empty'

module Lab42
  class Stream
    include Enumerable
    attr_reader :head, :promise


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

    def tail
      promise.()
    end

    private
    def initialize h, t=nil, &tail
      @head    = h
      @promise = ( t || tail ).memoized
    end
    
  end # class Stream
  module ::Kernel
    def binop_streams op, stream1, stream2
      combine_streams stream1, stream2 do |e1, e2|
        e1.send op, e2
      end
    end

    def combine_streams s1, s2, &operation
      return empty_stream if s1.empty? || s2.empty?
      cons_stream operation.(s1.head, s2.head) do
        combine_streams( s1.tail, s2.tail, &operation)
      end
    end

    def cons_stream head, &tail
      Lab42::Stream.new head, tail
    end

    def finite_stream enum
      e = enum.lazy
      cons_stream( e.peek ){ finite_stream e.drop( 1 ) }
    rescue StopIteration
      empty_stream
    end
  end # module ::Kernel

  class ::Proc
    def memoized
      already_run = false
      result      = nil
      ->{
        if already_run
          result
        else
          already_run = true
          result = call()
        end
      }
    end
  end # class ::Proc
end # module Lab42
