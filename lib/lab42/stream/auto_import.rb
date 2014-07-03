require_relative '../stream'

Stream = Lab42::Stream
EmptyStream = Lab42::Stream::EmptyStream

module Kernel
  def iterate *args, &blk
    Stream.iterate( *args, &blk )
  end
  alias_method :stream_by, :iterate
end # module Kernel
