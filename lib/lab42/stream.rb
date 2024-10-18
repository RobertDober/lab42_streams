# frozen_string_literal: true

require_relative 'stream/proc'
module Lab42
  class Stream
    require_relative 'empty_stream'
    require_relative 'stream/basic_class_methods'
    extend BasicClassMethods


    private
    def initialize(head, tail=nil, &promise)
      raise ArgumentError, "must not provide tail and promise" if tail && promise

      if tail
        raise ArgumentError, "tail must be a stream" unless tail.is_a?(Stream)
        @promise = -> {tail}
      else
        @promise = promise
      end
      @promise = @promise.memoized
    end

  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
