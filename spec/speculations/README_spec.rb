# DO NOT EDIT!!!
# This file was generated from "README.md" with the speculate_about gem, if you modify this file
# one of two bad things will happen
# - your documentation specs are not correct
# - your modifications will be overwritten by the speculate command line
# YOU HAVE BEEN WARNED
RSpec.describe "README.md" do
  # README.md:21
  context "Import the basic functions into Kernel (`cons_stream` and `the empty_stream`) and Lab42::Stream into main" do
    # README.md:24
    require 'lab42/stream/basic_imports'
    it "we have access to the_empty_stream (README.md:28)" do
      expect(the_empty_stream).to be_kind_of(EmptyStream)
    end
    it "to cons_stream (README.md:32)" do
      expect(cons_stream(1) {1}).to be_kind_of(Stream)

    end
  end
end