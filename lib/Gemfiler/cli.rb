module Gemfiler
  class CLI < Thor
    desc 'file', 'Organizes your Gemfile.'

    def file(gemfile='./Gemfile')
      cabinet = Gemfiler::Cabinet.new(gemfile)
      cabinet.collect!

      ap cabinet
    end
  end
end