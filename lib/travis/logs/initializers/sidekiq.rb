# frozen_string_literal: true

libdir = File.expand_path('../../../../', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'active_support/core_ext/hash/keys'

require 'travis/exceptions'
require 'travis/logs'
require 'travis/logs/helpers/database'
require 'travis/logs/helpers/s3'
require 'travis/logs/sidekiq'
require 'travis/metrics'

$stdout.sync = true
Travis.logger.info('Setting up Sidekiq')

Travis::Logs::Helpers::S3.setup
Travis::Exceptions.setup(Travis.config, Travis.config.env, Travis.logger)
Travis::Metrics.setup(Travis.config.metrics, Travis.logger)
Travis::Logs::Sidekiq.setup

require 'travis/logs/sidekiq/aggregate'
require 'travis/logs/sidekiq/archive'
require 'travis/logs/sidekiq/log_parts'
require 'travis/logs/sidekiq/purge'
