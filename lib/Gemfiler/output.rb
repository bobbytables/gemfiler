require 'erb'

module Gemfiler
  class Output
    attr_reader :filer

    def initialize(filer)
      @filer = filer
    end

    def write(gemfile)
      File.open(gemfile, 'w') do |file|
        file.write(content)
      end
    end

    def content
      erb = ERB.new(File.read(File.expand_path('../templates/gemfile.erb', __FILE__)), nil, '<>')
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
        gems << self.gem_line(gem)
        gems
      end
    end

    def longest_gem_name(group=nil)
      gems = group ? groups[group] : filer.uncategorized
      gems.inject(0) {|max, gem| gem[:name].length > max ? gem[:name].length : max }
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
      when Fixnum, TrueClass, FalseClass
        value.to_s
      end
    end

    # It's a short parameter name because my syntax highlighter doesn't like the word "gem"
    def gem_line(g, groups=nil)
      gem_name = g[:name]
      line = ["gem '#{gem_name}'"]

      space_between = longest_gem_name(groups) - gem_name.length

      if g[:version]
        line << (' ' * space_between) + "'#{g[:version]}'"
      elsif (g.length - 1) > 0
        line << (' ' * space_between) + g.inject([]) do |options, (key, value)|
          if key != :name
            options << ":#{key} => #{type_value(value)}"
          end

          options
        end.join(', ')
      end

      line.join(', ')
    end
  end
end