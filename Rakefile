require 'hoe'
require './lib/worlddb/version.rb'

## NB: plugin (hoe-manifest) not required; just used for future testing/development
Hoe::plugin :manifest   # more options for manifests (in the future; not yet)

Hoe.spec 'worlddb' do
  
  self.version = WorldDB::VERSION
  
  self.summary = "worlddb - world.db command line tool"
  self.description = summary

  self.urls    = ['https://github.com/geraldb/world.db.ruby']
  
  self.author  = 'Gerald Bauer'
  self.email   = 'opensport@googlegroups.com'
    
  # switch extension to .markdown for gihub formatting
  #  - auto-added from Manifest.txt (see define_spec in class Hoe)
  # self.readme_file  = 'README.md'
  # self.history_file = 'History.md'
  
  self.extra_deps = [
    ['activerecord', '~> 3.2']  # NB: will include activesupport,etc.
    ### ['sqlite3',      '~> 1.3']  # NB: install on your own; remove dependency
  ]
  
  self.licenses = ['Public Domain']

  self.spec_extras = {
    :required_ruby_version => '>= 1.9.2'
  }

end