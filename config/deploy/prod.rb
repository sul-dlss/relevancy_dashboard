server 'sul-solr-tester.stanford.edu', user: 'solr', roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'

set :sidekiq_roles, :app
set :sidekiq_processes, 4
