require 'forwarder'
module Lab42
  class Stream
    class Empty < Stream
      extend Forwarder
      # It is the nature of the EmptyStream instance to return itself for a plethora of methods
      # this can be expressed as follows:
      forward_all :combine, :__combine__,
                  :drop, :drop_unitl, :drop_while, 
                  :flatmap, :__flatmap__, :filter, :__filter__, 
                  :inject_stream, :__inject__, 
                  :lazy_take, :lazy_take_until, :lazy_take_while,
                  :make_cyclic, :map, :__map__,
                  :reduce,
                  :segment, :__segment__, :__scan__, :split_by, :split_by_value,
                  :zip, :__zip__,
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

      def scan initial, *args, &blk
        [initial]
      end

      def scan1 *args, &blk
        []
      end


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
