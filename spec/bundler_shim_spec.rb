require 'spec_helper'

describe Gemfiler::BundlerShim do
  let(:gemfile) { File.read('./spec/support/gemfiles/SampleGemfile') }
  subject { Gemfiler::BundlerShim.new }

  before(:each) { subject.gather(gemfile) }

  it 'enables gemspec' do
    subject.gemspec?.should be_true
  end

  it 'can define a ruby version' do
    subject.ruby_version[:version].should eq('1.9.2')
  end

  it 'can define a ruby version w/ engine' do
    subject.ruby_version[:engine].should eq('jruby')
  end

  it 'can define a ruby version w/ engine version' do
    subject.ruby_version[:engine_version].should eq('1.0')
  end
end