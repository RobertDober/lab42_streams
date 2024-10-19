# frozen_string_literal: true

require_relative '../behavior'
module Lab42
  B = Behavior
  class Stream
    module Enumerable
      def drop(n=1)
        s = self
        n.times do
          return s if s.empty?
          s = s.tail
        end
        s
      end

      def each
        s = self
        loop do
          yield s.head
          s = s.tail
        end
      end

      def reduce(fun=nil, &blk)
        reducer = B.mk_function(fun, blk, arity: 2, name: "reduce")
      end

      def take(n=1)
        return the_empty_stream if n.zero?
        cons_stream(head){ take(n-1) }
      end
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
