require 'spec_helper'

describe Rendition::Portrayal do
  describe '.attribute' do
    describe "given a simple attribute name" do
      let(:instance){ klass.new }
      let(:klass){ Class.new(described_class) do
        attribute :the_attribute
      end }

      it "defines the named settable/gettable attribute" do
        instance.the_attribute = :some_value
        expect( instance.the_attribute ).to eq(:some_value)
      end
    end

    describe "given multiple attribute names" do
      let(:instance){ klass.new }
      let(:klass){ Class.new(described_class) do
        attribute :a1, :a2, :a3
      end }

      it "defines all of the named attributes" do
        i = instance
        i.a1, i.a2, i.a3 = 1, 2, 3
        expect( [i.a1, i.a2, i.a3] ).to eq( [1, 2, 3] )
      end
    end
  end

  describe "an instance attribute defined using .attribute" do
    subject{ klass.new }
    let(:klass){ Class.new(described_class) do
      attribute :an_attribute
    end }

    describe "when assigned a callable object" do
      let(:callable){ double(:callable) }

      before do
        subject.an_attribute = callable
      end

      it "gets the result of #call on the assigned object" do
        allow( callable ).to receive(:call).and_return :call_result
        expect( subject.an_attribute ).to eq( :call_result )
      end

      it "reuses the previous #call result for subsequent gets" do
        expect( callable ).to receive(:call).once.and_return :call_result
        expect( subject.an_attribute ).to eq( :call_result )
        expect( subject.an_attribute ).to eq( :call_result )
      end
    end
  end
end
