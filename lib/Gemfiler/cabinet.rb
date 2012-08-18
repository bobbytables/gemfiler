module Gemfiler
  class Cabinet
    attr_reader :gemfile, :source_contents, :shim

    def initialize(gemfile)
      @gemfile = gemfile
      @shim    = BundlerShim.new
    end

    def gems
      self.shim.gems
    end

    def collect!
      @source_contents ||= File.read(gemfile)
      self.shim.gather(@source_contents)
    end
  end
end