class Proc
  def memoized
    already_run = false
    result      = nil
    ->{
      if already_run
        result
      else
        already_run = true
        result = call()
      end
    }
  end
end
