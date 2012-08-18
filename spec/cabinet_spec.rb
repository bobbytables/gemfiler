require 'spec_helper'

describe Gemfiler::Cabinet do
  subject { Gemfiler::Cabinet.new('./spec/support/gemfiles/SampleGemfile') }

  context '.collect' do
    it 'retrieves all gems and stores them.' do
      subject.collect
      subject.gems.should include({name: 'gemfiler'})
    end

    it 'retrieves gems with versions' do
      subject.collect
      subject.gems.should include({name: 'rspec', version: '2.11'})
    end
  end
end