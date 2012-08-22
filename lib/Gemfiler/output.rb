module Gemfiler
  class Output
    attr_reader :filer

    def initialize(filer)
      @filer = filer
    end

    def write(gemfile)
      content = []

      content << sources
      content << gemspec
      content << ruby

      ap content
    end

    def sources
      filer.shim.sources.inject([]) do |a, source|
        if source.kind_of? Symbol
          a << "source :#{source}"
        else
          a << "source '#{source}'"
        end
        
        a
      end.join("\n")
    end

    def gemspec
      filer.shim.gemspec? ? 'gemspec' : ''
    end

    def ruby
      parts = []

      if version_info = filer.shim.ruby_version
        parts << "ruby '#{version_info[:version]}'"
        parts << ":engine => '#{version_info[:engine]}'" if version_info[:engine]
        parts << ":engine_version => '#{version_info[:engine_version]}'" if version_info[:engine_version]
      end

      parts.join(', ')
    end
  end
end