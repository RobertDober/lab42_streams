module Enumerable
  def ordered_by beh

    sort do | a, b |
      a == b ? 0 : (
        beh.(a, b) ? -1 : 1
    )
    end

  end
end
