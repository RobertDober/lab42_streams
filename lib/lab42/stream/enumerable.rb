module Enumerable
  def to_stream; finite_stream self end
end

module Lab42
  class Stream
    module Enumerable
      def each bhv=nil, &blk
        bhv = blk.make_behavior bhv
        iter = self
        loop
          return if iter.empty?
          bhv.( iter.head )
          iter = iter.tail
        end

      def take n=1
        raise ArgumentError, "need a non negative Fixnum" if !(Fixnum === n) || n < 0
        x = []
        each do | ele |
          return x if n.zero?
          n -= 1
          x << ele
        end
        x
      end

      def take_while *bhv, &blk
        bhv = blk.make_behavior( *bhv )
        x = []
        each do | ele |
          return x unless bhv.( ele )
          x << ele
        end
        x
      end
        
    end # module Enumerable
  end # class Stream
end # module Lab42
