require 'spec_helper'

RSpec.describe "demo/010-basic-stream-tuto.md" do

     let(:translation){ { [true,true] => "fizzbuzz", [true, false] => "fizz", [false, true] => "buzz" } }
     let(:integers )  { Lab42::Stream.iterate 0, :succ }
     it "fizzbuzzes" do
     fizzbuzz    = integers
        .reject{ |x| (x%100).zero? }
        .map{ |i| [(i%3).zero?,(i%5).zero?,i] }
        .map{ |f,b,i| translation.fetch([f,b],i) }
     end
end
