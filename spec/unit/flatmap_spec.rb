require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  context "flatmap" do
    context "basic use case" do 

      let(:tripler){
        -> ele do
          finite_stream [ele, ele, ele]
        end
      }
      let(:tripled){[1,1,1,2,2,2,3,3,3]}
      let(:ts){finite_stream( 1..3 ).flatmap( tripler )}

      it "flattens one level" do
        expect(
          ts.to_a
        ).to eq(tripled)
      end

      it "REGRESSION:can be forced many times" do
        3.times do
          expect( ts.to_a ).to eq tripled
        end
      end
    end # context "basic use case"

    context "only streams are expanded" do 
      let( :error ){ 
        [ArgumentError, "flatmap can only map on streams, use flatmap_with_each to map over streams and enumerables"]
      }
      it 'raises an error' do
        expect( ->{
          finite_stream(1..2).flatmap{|a| [a,a] }
        }  ).to raise_error(*error)
      end
      it "even in the functional form" do
        expect( ->{
          flatmap(finite_stream(1..2)){|a| [a,a] }
        }  ).to raise_error(*error)
        
      end
    end # context "only streams are expanded"

    context "flatmap_with_each to the rescue" do 
      subject do
        iterate 0, :succ
      end
      let(:result){
        subject.flatmap_with_each expander
      }

      context "with enumerables" do
        let :expander do
          -> (n) {
            n.zero? ?  "zero" : (
              n.odd? ? [n, n] : [*0...n]
            )
          }
        end

        it "expands everything responding to each and copies the rest" do
          expect( result.take 11 ).to eq ["zero", 1, 1, 0, 1, 3, 3, 0, 1, 2, 3] 
        end

      end

      context "with enumerables and streams" do
        let :expander do
          -> (n) {
            n.zero? ?  "zero" : (
              n.odd? ? [n, n] : finite_stream(0...n)
            )
          }
        end

        it "expands everything responding to each and copies the rest" do
          expect( result.take 11 ).to eq ["zero", 1, 1, 0, 1, 3, 3, 0, 1, 2, 3] 
        end

      end

    end # context "flatmap_with_each to the rescue"
  end # context "flatmap"


end # describe Lab42::Stream
