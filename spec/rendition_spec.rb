require 'spec_helper'

describe Rendition do
  it 'should have a version number' do
    Rendition::VERSION.should_not be_nil
  end
end
