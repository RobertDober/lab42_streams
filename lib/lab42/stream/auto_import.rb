require_relative '../stream'

Stream = Lab42::Stream
EmptyStream = Lab42::Stream::EmptyStream

module Kernel
  alias_method :stream_by, :iterate
end # module Kernel
