require 'awesome_print'

module Gemfiler
  class CLI < Thor
    desc 'file', 'Organizes your Gemfile.'

    def file(gemfile='./Gemfile')
      cabinet = Gemfiler::Cabinet.new(gemfile)
      cabinet.collect!

      filer = Gemfiler::Filer.new(cabinet)
    end
  end
end