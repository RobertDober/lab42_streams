require 'lab42/core/hash'

module Lab42
  class Stream
    class Behavior

      def initialize( &blk )
        @behavior = blk
      end

      def call( *args )
        @behavior.( *args )
      end

      class << self

        def const(const_rval)
          __const_hash__.fetch!(const_rval, new{ |*_| const_rval})
        end

        def make(*args, &blk)
          if blk
            raise ArgumentError, "cannot specify behavior with block and args: #{args.inspect}" unless args.empty?
            blk
          else
            _make_from_args( args )
          end 
        end

        def make1(*args, &blk)
          if blk
            blk
          else
            _make_from_args( args )
          end 
        end
        private

        def _make_from_args( args )
          if args.first.respond_to?( :call )
            _curry( args )
          else
            -> (rcv, *a) do
              rcv.send(*(args + a))
            end 
          end
        end

        def _curry(args)
          -> ( *a ) do
            args.first.(*(args.drop(1)+a))
          end
        end

        def __const_hash__
          @__const_hash__ ||= {}
        end

      end
    end
  end
end
