require 'spec_helper'

describe Consensus::Portrayal do
  describe '.attribute' do
    let(:instance){ klass.new }

    context "given a simple attribute name" do
      let(:klass){ Class.new(described_class) do
        attribute :the_attribute
      end }

      it "defines the named settable/gettable attribute" do
        instance.the_attribute = :some_value
        expect( instance.the_attribute ).to eq(:some_value)
      end
    end

    context "given a name ending in \"?\"" do
      let(:klass){ Class.new(described_class) do
        attribute :ya_think?
      end }

      it "defines a non-\"?\" setter with a \"?\" getter" do
        instance.ya_think = :yes_i_do
        expect( instance.ya_think? ).to eq(:yes_i_do)
      end
    end

    context "given multiple attribute names" do
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

    context "when assigned a callable object" do
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

  describe '#fill_from' do
    subject{ klass.new }
    let(:klass){ Class.new(described_class) do
      attribute :a1, :a2, :a3, :a4, :eh?
    end }

    it "fills specified simply-named attributes from the given object" do
      source_obj = double(:source_obj, a1: 1, a2: 2, a3: 3, x: 4)
      subject.fill_from source_obj, [:a1, :a3]
      s = subject
      expect( [s.a1, s.a2, s.a3, s.a4 ] ).to eq( [1, nil, 3, nil] )
    end

    it "fills a specified attribute with name ending in \"?\" from the given object" do
      source_obj = double(:source_obj, :eh? => :nope)
      subject.fill_from source_obj, [:eh?]
      expect( subject.eh? ).to eq( :nope )
    end

    it "lazily fills attributes from the source object when the lazy option is specified" do
      source_obj = double(:source_obj, a1: :ay_one, a2: :ay_two)

      subject.fill_from source_obj, [:a1, :a2], lazy: true
      expect( source_obj ).not_to have_received( :a1 )
      expect( source_obj ).not_to have_received( :a2 )

      expect( subject.a1 ).to eq( :ay_one )
      expect( source_obj ).to     have_received( :a1 ).once
      expect( source_obj ).not_to have_received( :a2 )

      expect( subject.a1 ).to eq( :ay_one )
      expect( subject.a2 ).to eq( :ay_two )
      expect( source_obj ).to have_received( :a1 ).once
      expect( source_obj ).to have_received( :a2 ).once
    end
  end
end
