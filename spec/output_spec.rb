require 'spec_helper'

describe Gemfiler::Output do
  let(:cabinet) { Gemfiler::Cabinet.new('./spec/support/gemfiles/SampleGemfileForOutput') }
  let(:filer) { Gemfiler::Filer.new(cabinet) }

  subject { Gemfiler::Output.new(filer) }

  context 'gemfile output methods' do
    before(:each) { cabinet.collect! }

    it '.source returns sources' do
      subject.sources.should match /source 'http:\/\/rubygems\.org'/
    end

    it '.source returns sources as symbols' do
      subject.sources.should match /source \:rubygems/
    end

    it '.gemspec returns a gemspec line' do
      subject.gemspec.should match /gemspec/
    end

    it '.ruby returns the correct ruby definition' do
      subject.ruby.should match /ruby '1.9.3'/
    end
  end
end