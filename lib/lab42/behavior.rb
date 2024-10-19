# frozen_string_literal: true

module Lab42
  module Behavior extend self
    class Undfined < Exception
    end

    def mk_function(fun, blk, arity: nil, name: nil)
      raise ArgumentError, "must not provide a function **and** a block in `#{name || "mk_function"}`" if fun && blk
      return _mk_function(fun, arity:) if fun
      _arity_check(blk, arity:)
    end

    private
    def _mk_array_function(ary, arity:)
      missing = ary.length - 1 - arity
      if missing.zero?
        -> (x) { x.send(*ary.drop(1)) }$$

    end

    def _mk_function(fun, arity:)
      case fun
      when Symbol
        _mk_symbol_function(fun, arity:)
      when Array
        _mk_array_function(fun, arity:)
      end
    end

    def _mk_symbol_function(fun, arity:)
      if arity.one?
        -> (x) { x.send(fun) }
      elsif arity == 2
        -> (x, y) { x.send(fun, y) }
      else
        raise Undefined, "only arity 1 and 2 is supported for symbolized function"
      end
    end
  end
end
# SPDX-License-Identifier: AGPL-3.0-or-later
