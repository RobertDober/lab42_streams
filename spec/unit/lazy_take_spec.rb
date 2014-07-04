require 'spec_helper'

describe Lab42::Stream do 
  context 'lazy_take' do 
    context "empty" do 
      it 'is empty for empty' do
        expect( empty_stream.lazy_take 42 ).to be_empty
      end
    end # context "empty"

    context "finite" do 
      let(:three){1..3}
      subject do
        three.to_stream
      end

      it "can take one" do
        one = subject.lazy_take
        expect( one.head ).to eq 1
        expect( one.tail ).to be_empty
      end
      it "can take more" do
        many = subject.lazy_take 42
        expect( many.entries ).to eq [*three]
      end
    end # context "finite"
    
    context "infinite" do 
      subject do
        iterate 0, :succ
      end
      it 'can take many' do
        many = subject.drop(10).lazy_take( 25 )
        expect( many.entries ).to eq([*10..34])
      end
    end # context "infinite"
  end # context 'lazy_take'
  context 'lazy_take_while (until)', :wip do
    context "empty" do 
      it 'is empty for empty' do
        expect( empty_stream.lazy_take_while :true ).to be_empty
      end
    end # context "empty"

    context "finite" do 
      let(:three){1..3}
      subject do
        three.to_stream
      end

      it "can take one" do
        one = subject.lazy_take_while :<, 2
        expect( one.head ).to eq 1
        expect( one.tail ).to be_empty
      end
      it "can take more" do
        many = subject.lazy_take_while ->(a){ a < 42 }
        expect( many.entries ).to eq [*three]
      end
    end # context "finite"
    
    context "infinite" do 
      subject do
        iterate 0, :succ
      end
      it 'can take many (while)' do
        many = subject.drop(10).lazy_take_while{ |n| n < 35 }
        expect( many.entries ).to eq([*10..34])
      end

      it 'can take many (until)' do
        many = subject.drop(10).lazy_take_until{ |n| n > 34}
        expect( many.entries ).to eq([*10..34])
      end
    end # context "infinite"
  end # context 'lazy_take'
end # describe Lab42::Stream
