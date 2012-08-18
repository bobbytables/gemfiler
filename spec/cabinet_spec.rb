require 'spec_helper'

describe Gemfiler::Cabinet do
  subject { Gemfiler::Cabinet.new('./spec/support/gemfiles/SampleGemfile') }

  context '.collect' do
    before(:each) { subject.collect! }

    it 'retrieves all gems and stores them.' do
      subject.gems.should include({name: 'gemfiler'})
    end

    it 'retrieves gems with versions' do
      subject.gems.should include({name: 'rspec', version: '2.11'})
    end

    it 'applies groups in block syntax' do
      subject.gems.should include({name: 'somegem', groups: ['test']})
    end

    it 'applies platforms in block syntax' do
      subject.gems.should include({name: 'plat', platforms: ['ruby']})
    end

    it 'applies git sourced gems in block syntax' do
      subject.gems.should include({name: 'rails', git: 'git://github.com/rails/rails.git'})
    end

    it 'applies git sourced gems in block syntax with git options' do
      subject.gems.should include({name: 'rails2', git: 'git://github.com/rails/rails.git', ref: '2f7cb5e9'})
    end

    it 'always puts a gem group into the plural key' do
      subject.gems.should include({name: 'somegemthesecond', groups: ['test2']})
    end
  end
end