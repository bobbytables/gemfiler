require_relative "gemfiler/version"

module Gemfiler
  autoload :Cabinet,     'gemfiler/cabinet'
  autoload :BundlerShim, 'gemfiler/bundler_shim'
  autoload :Filer,       'gemfiler/filer'
  autoload :CLI,         'gemfiler/cli'
end
