require 'erb'

module Gemfiler
  class Output
    attr_reader :filer

    def initialize(filer)
      @filer = filer
    end

    def write(gemfile)
      File.open(File.expand_path('~/Sites/testing.txt', __FILE__), 'w') do |file|
        file.write(content)
      end
    end

    def content
      erb = ERB.new(File.read(File.expand_path('../templates/gemfile.erb', __FILE__)))
      erb.result(binding)
    end

    def sources
      filer.shim.sources.inject([]) do |sources, source|
        sources << "source #{type_value(source)}"
        sources
      end
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

    def uncategorized_gems
      filer.uncategorized.inject([]) do |gems, gem|
        gems << gem_line(gem)
        gems
      end
    end

    def groups
      filer.groups
    end

    def spacer
      '  '
    end

    def type_value(value)
      case value
      when Symbol
        ":#{value.to_s}"
      when String
        "'#{value}'"
      when Fixnum
        value.to_s
      when TrueClass, FalseClass
        
      end
    end

    # It's a short parameter name because my syntax highlighter doesn't like the word "gem"
    def gem_line(g)
      gem_name = g.delete(:name)
      line = ["gem '#{gem_name}'"]

      if g[:version]
        line << "'#{g[:version]}'"
      elsif g.length > 0
        line << g.inject([]) do |options, (key, value)|
          options << ":#{key} => #{type_value(value)}"
          options
        end.join(', ')
      end

      line.join(', ')
    end
  end
end