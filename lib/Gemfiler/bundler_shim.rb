module Gemfiler
  class BundlerShim
    attr_accessor :gems, :ruby_version, :sources, :has_gemspec
    attr_reader :cabinet

    def initialize
      @gems         = []
      @sources      = []
      @ruby_version = nil
      @has_gemspec  = false
    end

    def gather(source)
      source = source.gsub /source[\s]+\:([\w_]+)/, 'source(:\\1)'
      instance_eval(source)
    end

    def gemspec?
      @has_gemspec
    end

    def gem(name, *args)
      gem = {name: name}

      case args.first
      when String
        gem[:version] = args.first
      when Hash
        gem.merge! args.first
      end

      gem[:groups]    = @groups.map(&:to_s) if @groups
      gem[:platforms] = @platforms.map(&:to_s) if @platforms

      if @git
        gem[:git] = @git
        gem.merge! @git_options
      end

      if gem[:group]
        gem[:groups] ||= []
        gem[:groups] << gem.delete(:group)
      end

      @gems << gem

      gem
    end

    def gemspec
      @has_gemspec = true
    end

    def ruby(version, engine={})
      @ruby_version = {version: version}.merge(engine)
    end

    def source(source)
      @sources << source
    end

    def group(*names, &block)
      @groups = names.uniq
      self.instance_eval(&block)
      @groups = nil
    end

    def platforms(*names, &block)
      @platforms = names.uniq
      self.instance_eval(&block)
      @platforms = nil
    end

    def git(url, options={}, &block)
      @git         = url
      @git_options = options

      self.instance_eval(&block)
      
      @git         = nil
      @git_options = nil
    end
  end
end