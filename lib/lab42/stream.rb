
require_relative './stream/empty'
require_relative './stream/delayed'
require_relative './stream/kernel'
require_relative './stream/array'
require_relative './stream/enumerable'
require_relative './stream/higher_order'
require_relative './stream/proc'
require_relative './stream/class_methods'
require_relative './stream/utility'

require_relative './stream/kernel/extensions'

module Lab42
  class Stream
    extend ClassMethods

    ConstraintError = Class.new RuntimeError
    attr_reader :head, :promise
    alias_method :first, :head

    def append other
      raise ArgumentError, "not a stream #{other}" unless self.class === other
      cons_stream( head ){ tail.append other }
    end
    alias_method :+, :append


    def combine_streams *args, &operation
      op = args.shift unless self.class === args.first
      raise ArgumentError, "Missing stream parameters" if args.empty?
      __combine_streams__ Behavior.make( op, &operation), args
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

    def empty?; false end

    def tail
      promise.()
    end

    def to_stream; self end

    def __combine_streams__ op, args
      return empty_stream if args.any?(&:empty?)

      new_head = op.(head, *args.map(&:head))
      cons_stream( new_head ){ tail.__combine_streams__(op, args.map(&:tail)) }
    end

    private
    def initialize h, t=nil, &tail
      @head    = h
      @promise = ( t || tail ).memoized
    end

    # def mk_proc args
    #   return args if Proc === args
    #   raise ArgumentError, "neither a Proc nor an array of args for Kernel#sendmsg" unless Array === args
    #   return args.first if Proc === args.first || Method === args.first
    #   sendmsg(*args)
    # end

  end # class Stream

end # module Lab42
