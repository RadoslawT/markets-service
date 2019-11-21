# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://markets-service-redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://markets-service-redis:6379/0' }
end

schedule_file = 'config/schedule.yml'

Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?

Sidekiq.options[:poll_interval] = 5
