require "awesome_print"

module Gemfiler
  class CLI < Thor

    desc "file", "Organizes your Gemfile."
    method_options nice_spaces: :boolean, ruby19_hashes: :boolean
    def file(gemfile="Gemfile")
      gemfile = "#{Dir.pwd}/#{gemfile}"

      cabinet = Gemfiler::Cabinet.new(gemfile)
      cabinet.collect!

      filer  = Gemfiler::Filer.new(cabinet)
      filer.group
      filer.alphabetize
      output = Gemfiler::Output.new(filer, options)

      output.write(gemfile)
    end
  end
end