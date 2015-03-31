require "erb"
require "json"
require "net/http"

module Gemfiler
  class Output
    attr_reader :filer, :options

    def initialize(filer, options={})
      @filer   = filer
      @options = options
    end

    def write(gemfile)
      File.open(gemfile, "w") do |file|
        file.write(content)
      end
    end

    def content
      erb = ERB.new(File.read(File.expand_path("../templates/gemfile.erb", __FILE__)), nil, "<>")
      erb.result(binding)
    end

    def sources
      filer.shim.sources.inject([]) do |sources, source|
        sources << "source #{type_value(source)}"
        sources
      end
    end

    def gemspec
      filer.shim.gemspec? ? "gemspec" : ""
    end

    def ruby
      parts = []
      if version_info = filer.shim.ruby_version
        parts << "ruby '#{version_info[:version]}'"
        parts << hash_keyvalue(:engine, version_info[:engine]) if version_info[:engine]
        parts << hash_keyvalue(:engine_version, version_info[:engine_version]) if version_info[:engine_version]
      end

      parts.join(", ")
    end

    def uncategorized_gems
      filer.uncategorized.inject([]) do |gems, gem|
        gems << self.gem_line(gem)
        gems
      end
    end

    def longest_gem_name(group=nil)
      @longest ||= {}
      gems = group ? groups[group] : filer.uncategorized
      @longest[group] ||= gems.inject(0) {|max, gem| gem[:name].length > max ? gem[:name].length : max }
    end

    def groups
      filer.groups
    end

    def spacer
      "  "
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

    def hash_keyvalue(key, value)
      if @options[:ruby19_hashes]
        "#{key.to_s}: #{type_value(value)}"
      else
        "#{type_value(key)} => #{type_value(value)}"
      end
    end

    # It's a short parameter name because my syntax highlighter doesn't like the word "gem"
    def gem_line(g, groups=nil)
      gem_name = g[:name]
      line     = ["gem '#{gem_name}'"]

      space_between = @options[:nice_spaces] ? longest_gem_name(groups) - gem_name.length : 0

      if g[:version]
        line << (" " * space_between) + "'#{g[:version]}'"
      elsif (g.length - 1) > 0
        line << (" " * space_between) + g.inject([]) do |options, (key, value)|
          if key != :name
            options << hash_keyvalue(key, value)
          end

          options
        end.join(", ")
      end

      annotation = ""

      if @options[:annotate]
        puts "-- Annotating #{gem_name}"
        uri = URI.parse("https://rubygems.org/api/v1/gems/#{gem_name}.json")
        response = Net::HTTP.get_response(uri)

        if response.kind_of?(Net::HTTPFound)
          parsed = JSON.load(response.body)
          info = parsed['info']

          annotation = " # #{info}"
        else
          puts "---- Gem #{gem_name} not a valid gem"
        end
      end

      line.join(", ") + annotation
    end
  end
end