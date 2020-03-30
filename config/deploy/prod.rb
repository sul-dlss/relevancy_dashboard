server 'sw-relevancy-prod.stanford.edu', user: 'blacklight', roles: %w(web db app)

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'

set :sidekiq_roles, :app
set :sidekiq_processes, 2
