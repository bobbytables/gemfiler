require 'spec_helper'

describe Gemfiler::Filer do
  let(:cabinet) { Gemfiler::Cabinet.new('./spec/support/gemfiles/SampleGemfileForGroups') }
  subject { Gemfiler::Filer.new(cabinet) }

  context 'gem groups' do
    before(:each) do
      cabinet.collect!
      subject.group
    end

    it 'are gathered correctly' do
      subject.groups[['randomgroup']].size.should eq(3)
    end

    it 'expose uncategorized gems' do
      subject.uncategorized.size.should eq(3)
    end
  end

  context 'alphabitizer' do
    before(:each) do
      cabinet.collect!
      subject.group
    end

    it 'alphabetizes uncategorized gems correctly' do
      subject.alphabetize
      subject.uncategorized.first[:name].should eq('aaa')
    end

    it 'alphabetizes grouped gems correctly' do
      subject.alphabetize
      subject.groups[['randomgroup']].first[:name].should eq('bbb')
    end
  end
end