# frozen_string_literal: true

module Lab42
  class EmptyStream < Stream
    def empty? = true
    def head = raise StopIteration, "empty stream, headless!"
    def tail = raise StopIteration, "empty stream, end of the journey"

    private
    def initialize = nil
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
