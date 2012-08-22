require 'awesome_print'

module Gemfiler
  class CLI < Thor
    desc 'file', 'Organizes your Gemfile.'

    def file(gemfile='Gemfile')
      gemfile = "#{Dir.pwd}/#{gemfile}"

      cabinet = Gemfiler::Cabinet.new(gemfile)
      cabinet.collect!

      filer  = Gemfiler::Filer.new(cabinet)
      filer.group
      filer.alphabetize
      output = Gemfiler::Output.new(filer)

      output.write(gemfile)
    end
  end
end