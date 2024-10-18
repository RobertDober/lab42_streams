# frozen_string_literal: true

module Lab42
  class Stream
    module BasicClassMethods
      def cons_stream head, tail=nil, &promise
        Stream.new(head, tail, &promise)
      end

      def the_empty_stream = Lab42::EmptyStream.new
      
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
