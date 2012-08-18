module Gemfiler
  module BundlerMethods
    def gem(name, *args)
      gem = {name: name}

      case args.first
      when String
        gem[:version] = args.first
      when Hash
        gem.merge! args.first
      end

      gem[:groups] = @groups.map(&:to_s) if @groups

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
      @ruby_version = {version: version, engine: engine[:engine], engine_version: engine[:engine_version]}
    end

    def source(source)
      @sources ||= []
      @sources << source
    end

    def group(*names, &block)
      @groups = names.uniq
      self.instance_eval(&block)
      @groups = nil
    end
  end
end