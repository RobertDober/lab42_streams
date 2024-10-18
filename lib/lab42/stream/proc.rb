# frozen_string_literal: true

class Proc
  def memoized
    already_run = false
    result      = nil
    -> do
      if already_run
        result
      else
        already_run = true
        result = call()
      end
    end 
  end

end
# SPDX-License-Identifier: AGPL-3.0-or-later
