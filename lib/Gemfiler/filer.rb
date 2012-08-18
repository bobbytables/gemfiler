module Gemfiler
  class Filer
    attr_accessor :cabinet, :groups, :uncategorized

    def initialize(cabinet)
      @cabinet       = cabinet
      @groups        = {}
      @uncategorized = []
    end

    def group
      cabinet.gems.each do |gem|
        if gem[:groups]
          gem_groups           = gem[:groups].sort
          groups[gem_groups] ||= []
          groups[gem_groups] << gem
        else
          uncategorized << gem
        end
      end
    end

    def alphabetize
      self.uncategorized = alphabetize_from_array(self.uncategorized)

      self.groups = self.groups.inject({}) do |hash, (groups, gems)|
        hash[groups] = alphabetize_from_array(gems)
        hash
      end
    end

    def sources
      cabinet.shim.sources.inject([]) do |a, source|
        a << "source '#{source}'"
        a
      end.join("\n")
    end

    def gemspec
      cabinet.shim.gemspec? ? 'gemspec' : ''
    end

    def ruby
      parts = []

      if version_info = cabinet.shim.ruby_version
        parts << "ruby '#{version_info[:version]}'"
        parts << ":engine => '#{version_info[:engine]}'" if version_info[:engine]
        parts << ":engine_version => '#{version_info[:engine_version]}'" if version_info[:engine_version]
      end

      parts.join(', ')
    end

    private

    def alphabetize_from_array(gems)
      gems.sort_by {|g| g[:name] }
    end
  end
end