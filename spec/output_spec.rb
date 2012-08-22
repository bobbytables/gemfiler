require 'spec_helper'

describe Gemfiler::Output do
  let(:cabinet) { Gemfiler::Cabinet.new('./spec/support/gemfiles/SampleGemfileForOutput') }
  let(:filer) { Gemfiler::Filer.new(cabinet) }

  subject { Gemfiler::Output.new(filer) }

  context 'gemfile output methods' do
    before(:each) do 
      cabinet.collect!
      filer.group
      filer.alphabetize
    end

    it '.source returns sources' do
      subject.sources.should include "source 'http://rubygems.org'"
    end

    it '.source returns sources as symbols' do
      subject.sources.should include 'source :rubygems'
    end

    it '.gemspec returns a gemspec line' do
      subject.gemspec.should match /gemspec/
    end

    it '.ruby returns the correct ruby definition' do
      subject.ruby.should match /ruby '1.9.3'/
    end

    context '.uncategorized_gems' do
      it 'returns alphabitized gems' do
        organized_gems = ['aaa', 'bbb', 'ccc']
        subject.uncategorized_gems.each do |gem|
          gem.should match "gem '#{organized_gems.shift}'"
        end
      end

      it 'returns alphabitized gems with version' do
        subject.uncategorized_gems[0].should match /gem 'aaa', '1'/
      end

      it 'returns alphabitized gems with options' do
        subject.uncategorized_gems[1].should match /gem 'bbb', :path => 'mygempath'/
      end

      it 'returns alphabitized gems with multiple options' do
        subject.uncategorized_gems[2].should match /gem 'ccc', :path => 'awesomepath', :require => 'asd'/
      end
    end
  end
end