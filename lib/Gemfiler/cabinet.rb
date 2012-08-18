module Gemfiler
  class Cabinet
    include BundlerMethods

    attr_accessor :gems
    attr_reader :source, :source_contents

    # Bundler Specific accessors
    attr_accessor :ruby_version, :sources, :has_gemspec

    def initialize(source)
      @source = source
      @gems   = []
    end

    def collect
      @source_contents ||= File.read(source)
      eval(@source_contents)
    end
  end
end