require 'forwarder'

require_relative 'empty/enumerable'

module Lab42
  class Stream
    class Empty < Stream
      extend Forwarder
      # It is the nature of the EmptyStream instance to return itself for a plethora of methods
      # this can be expressed as follows:
      forward_all :drop, :drop_unitl, :drop_while, 
                  :flatmap, :__flatmap__, :filter, :__filter__, 
                  :inject_stream, :__inject__, 
                  :make_cyclic, :map, :__map__,
                  :reduce,
         to_object: :self, as: :itself

      def append other
        raise ArgumentError, "not a stream #{other}" unless self.class.superclass === other
        # ??? Is the to_stream message a good idea
        other.to_stream
      end
      alias_method :+, :append

      def empty?; true end


      def head; raise StopIteration, "head called on empty stream" end
      def tail; raise StopIteration, "tail called on empty stream" end


      def inject *args; args.first end
      alias_method :__inject__, :inject

      # TODO: Move this into lab42/core as Object#itself
      def itself *args, &blk; self end

      private

      def self.new
        @__instance__ ||= allocate
      end

    end # class Empty

    module ::Kernel
      def empty_stream; Empty.new end
      Lab42::Stream::EmptyStream = empty_stream
    end # module ::Kernel
  end # class Stream
end # module Lab42
