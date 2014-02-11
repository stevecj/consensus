require 'spec_helper'

describe Consensus do
  it 'should have a version number' do
    Consensus::VERSION.should_not be_nil
  end
end
