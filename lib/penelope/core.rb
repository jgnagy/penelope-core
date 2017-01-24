# Standard Library Requirements
require 'fileutils'

# External Requirements
require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-serializer'
require 'dm-types'
require 'dm-transactions'
require 'rjgit'
require 'resque'

require 'jdbc/mysql'
Jdbc::MySQL.load_driver

module Penelope
  # The core Penelope queued job module
  module Core
    CONFIG = {
      data: {
        directory: File.expand_path(
          ENV['PENELOPE_DATA_DIR'] ? ENV['PENELOPE_DATA_DIR'] : File.join('~', '.penelope', 'data')
        )
      },
      debug: false,
      db: {
        adapter:  'mysql',
        pool:     ENV['PENELOPE_DB_POOL_SIZE'] ? ENV['PENELOPE_DB_POOL_SIZE'] : 5,
        host:     ENV['PENELOPE_DB_HOST'] ? ENV['PENELOPE_DB_HOST'] : 'localhost',
        database: ENV['PENELOPE_DB_NAME'] ? ENV['PENELOPE_DB_NAME'] : 'penelopedb'
      }
    }
    CONFIG[:db][:username] = ENV['PENELOPE_DB_USER'] if ENV['PENELOPE_DB_USER']
    CONFIG[:db][:password] = ENV['PENELOPE_DB_PASSWORD'] if ENV['PENELOPE_DB_PASSWORD']
    CONFIG[:debug] = true if ENV['PENELOPE_DEBUG'] == 'true'
  end
end

# Internal Requirements
require "penelope/core/version"
require 'penelope/core/job_report'
require "penelope/core/job"
require "penelope/core/git_job"

# Setup the data store
puts '>> Connecting to DB'
DataMapper::Logger.new(STDOUT, :debug) if Penelope::Core::CONFIG[:debug]
adapter = DataMapper.setup(:default, Penelope::Core::CONFIG[:db])
adapter.resource_naming_convention =
  DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule

# Finish the data store setup
DataMapper.finalize
DataMapper.auto_upgrade!
