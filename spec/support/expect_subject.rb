module ExpectSubject
  def expect_subject; expect subject end
end # module ExpectSubject
RSpec.configure do | conf |
  conf.include ExpectSubject
end
