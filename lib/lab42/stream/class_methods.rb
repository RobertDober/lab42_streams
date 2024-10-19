# frozen_string_literal: true

module Lab42
  class Stream
    module ClassMethods
      def integers(start: 0, step: 1)
        cons_stream(start) { integers(start: start+step, step:) }
      end
      
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
