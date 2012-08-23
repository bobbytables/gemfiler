
# Gemfiler

Gemfiler will take your Gemfile and make it nice. It will alphabetize and group everything correctly. It can also turn hash syntax into Ruby's 1.9 hash syntax, and align versions / options nicely.

## Installation

```gem install gemfiler```


## Usage

Once you've installed gemfiler, you'll get the ```gemfiler``` executable.

  * cd into the project with the gemfile you'd like to prettify.
  * type ```gemfiler file``` (If you'd like to specify a Gemfile, type ```gemfiler file OtherGemfile```)
  * Voila!

To see a list of options, type ```gemfiler help file```

## Additional Options

```gemfiler file --ruby19_hashes``` Will use the 1.9 hash syntax

```gemfiler file --nice_spaces``` Will align all versions / options

## Before / After

### Before

```ruby
source 'http://rubygems.org'
 
gem 'state_machine'
gem 'validates_timeliness', '~> 3.0.2'
gem 'gmaps4rails'
gem 'chronic'
gem 'paper_trail'
gem 'no_peeping_toms', :git => 'git://github.com/patmaddox/no-peeping-toms.git'
gem "tire", :git => 'git@github.com:bobbytables/tire.git', :ref => '543f4b410f6c7b4ce62b4b866fb45a2339642b16'
gem 'draper', '~> 0.9'

```

### After

```ruby
source :rubygems 
 
gem 'chronic' 
gem 'draper',               '~> 0.9' 
gem 'gmaps4rails' 
gem 'no_peeping_toms',      git: 'git://github.com/patmaddox/no-peeping-toms.git' 
gem 'paper_trail' 
gem 'state_machine' 
gem 'tire',                 git: 'git@github.com:bobbytables/tire.git', ref: '543f4b410f6c7b4ce62b4b866fb45a2339642b16' 
gem 'validates_timeliness', '~> 3.0.2' 

```


## Gotchas
  Gemfiler works by acting like Bundler, it executes the Gemfile under a shim, and passes all of the gems as objects around Gemfiler.

  * Comments go away (Working on this)
  * Statements will go away, if you have any if statements, or anything other than bundler commands, it will either fail or remove the statement.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
