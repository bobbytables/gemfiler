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

    # Delegate shim
    def shim
      cabinet.shim
    end

    private

    def alphabetize_from_array(gems)
      gems.sort_by {|g| g[:name] }
    end
  end
end