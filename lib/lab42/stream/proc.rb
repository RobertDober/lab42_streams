class Proc
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

  # TODO: Use this from core/fn as soon as available
  def make_behavior *args
    raise ArgumentError, "cannot specify behavior with block and args: #{args.inspect}" unless args.compact.empty?
    self
  end

  def not
    -> (*args, &blk) {
      ! self.(*args, &blk)
    }
  end
end

class NilClass
  # TODO: Use this from core/fn as soon as available
  def make_behavior *args
    return args.first if args.size == 1 && args.first.respond_to?( :call )

    return ->(*a){
      args.first(*(args.drop(1)+a))
    } if args.first.respond_to?( :call )

    sendmsg( *args )
  end
end
