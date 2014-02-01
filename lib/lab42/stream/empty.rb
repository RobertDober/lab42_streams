require 'forwarder'

module Lab42
  class Stream
    class Empty < Stream
      extend Forwarder
      # TODO replace with
      # forward_all ..., as_result: :self
      forward_all :flatmap, :__flatmap__,
                  :filter, 
                  :inject_stream, :__inject__, :reduce_stream,
                  :make_cyclic, :map, :tail,
         to_object: :self, as: :itself

      def append other
        raise ArgumentError, "not a stream #{other}" unless self.class.superclass === other
        # ??? Is the to_stream message a good idea
        other.to_stream
      end
      alias_method :+, :append

      def empty?; true end


      def head; raise StopIteration, "head called on empty stream" end

      # TODO: Move this into lab42/core as Object#itself
      def itself *args, &blk; self end

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
