require 'spec_helper'

describe Lab42::Stream do 
  context "scan and scan1" do
    context "empty_stream" do
      it 'returns an array of the injected value' do
        expect( empty_stream.scan(:alpha,:not_existing_method) ).to eq [:alpha]
        expect( empty_stream.scan(:alpha,->{}) ).to eq [:alpha]
        expect( empty_stream.scan(:alpha){raise RuntimeError} ).to eq [:alpha]
      end
      it 'returns [] for scan1' do
        expect( empty_stream.scan1(:not_existing_method) ).to eq []
        expect( empty_stream.scan1(->{}) ).to eq []
        expect( empty_stream.scan1{raise RuntimeError} ).to eq []
      end
    end # context "empty_stream"

    context "finite streams" do
      context "one element stream" do 
        subject do
          finite_stream [42]
        end
        it 'worx with scan' do
          expect( subject.scan( 1, :+ ).to_a ).to eq [1, 43]
        end
        it 'worx with scan1' do
          expect( subject.scan1( :+ ).to_a ).to eq [42]
          expect( subject.scan1{ raise RuntimeError }.to_a ).to eq [42]
        end
      end # context "one element stream"

      context "some more elmements" do 
        subject do
          finite_stream 1..3
        end
        it 'worx with scan' do
          expect( subject.scan(1, :+).to_a ).to eq [1, 2, 4, 7]
        end
        it 'worx with scan1' do
          expect( subject.scan1( :+ ).to_a ).to eq [1, 3, 6]
        end
        # it 'will execute the lambda', :wip do
        #   expect( ->{subject.scan1{|*args| raise RuntimeError; empty_stream}} ).to raise_error
        # end
      end # context "some more elmements"
    end # context "finite_stream"

    context 'infinite streams' do 
      context 'scan' do 
        subject do
          iterate( 1, :succ ).scan 2, :*
        end
        it 'worx' do
          expect( subject.take 5 ).to eq [2, 2, 4, 12, 48]
        end

      end # context 'scan'
      context 'scan1' do 
        subject do
          iterate( 0, :succ ).scan1 :+
        end
        it 'worx' do
          expect( subject.take 5 ).to eq [0, 1, 3, 6, 10]
        end

      end # context 'scan1'

    end # context 'infinite streams'
  end # context "scan and scan1"
end # describe Lab42::Stream
