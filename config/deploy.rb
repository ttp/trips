require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain,      '138.201.154.11'
set :user,        'rails'
set :repository,  'git@github.com:ttp/trips.git'
set :branch,      'master'
set :deploy_to,   '/home/rails/www/pohody.com.ua'
set :rails_env,   'production'
set :keep_releases, 5

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []) + [
  'log',
  'tmp',
  'public/system',
  'public/media',
  'public/sitemaps'
]

set :shared_files, [
  'config/database.yml',
  'config/environments/production.rb',
  'config/secrets.yml',
  'config/initializers/devise.rb'
]

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.

task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.3.1@default'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task setup: :environment do
  command %(mkdir -p "#{fetch(:shared_path)}/log")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/log")

  command %(mkdir -p "#{fetch(:shared_path)}/tmp/sockets")
  command %(mkdir -p "#{fetch(:shared_path)}/tmp/pids")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids")

  command %(mkdir -p "#{fetch(:shared_path)}/config")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/config")

  command %(mkdir -p "#{fetch(:shared_path)}/config/initializers")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/config/initializers")

  command %(mkdir -p "#{fetch(:shared_path)}/config/environments")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/config/environments")

  command %(mkdir -p "#{fetch(:shared_path)}/public/system")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/system")
  command %(mkdir -p "#{fetch(:shared_path)}/public/media")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/media")
  command %(mkdir -p "#{fetch(:shared_path)}/public/sitemaps")
  command %(chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/sitemaps")

  command %(touch "#{fetch(:shared_path)}/config/database.yml")
  command %(touch "#{fetch(:shared_path)}/config/secrets.yml")
  command %(touch "#{fetch(:shared_path)}/config/environments/production.rb")
  command %(touch "#{fetch(:shared_path)}/config/initializers/devise.rb")
  command %(echo "-----> Be sure to edit '#{fetch(:shared_path)}/config*'.")
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  deploy do
    on :prepare do
    end

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'passenger:restart'
    end
  end
end

desc 'Seed data to the database'
task seed: :environment do
  command "cd #{fetch(:current_path)}/"
  command "bundle exec rake db:seed RAILS_ENV=#{fetch(:rails_env)}"
  command %(echo "-----> Rake Seeding Completed.")
end

namespace :unicorn do
  set :unicorn_pid, "#{fetch(:current_path)}/tmp/pids/unicorn.pid"
  set :start_unicorn, %(
    cd #{fetch(:current_path)}
    bundle exec unicorn -c #{fetch(:current_path)}/config/unicorn.rb -E #{fetch(:rails_env)} -D
    )

  # Start task
  # ------------------------------------------------------------------------------
  desc 'Start unicorn'
  task start: :environment do
    command 'echo "-----> Start Unicorn"'
    command start_unicorn
  end

  # Stop task
  # ------------------------------------------------------------------------------
  desc 'Stop unicorn'
  task :stop do
    command 'echo "-----> Stop Unicorn"'
    command %(
      test -s "#{unicorn_pid}" && kill -QUIT `cat "#{unicorn_pid}"` && echo "Stop Ok" && exit 0
      echo >&2 "Not running"
        )
  end

  # Restart task
  # ------------------------------------------------------------------------------
  desc "Restart unicorn using 'upgrade'"
  task restart: :environment do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end

namespace :passenger do
  task :restart do
    command "touch #{fetch(:current_path)}/tmp/restart.txt"
  end
end

namespace :jobs do
  task stop: :environment do
    command 'echo "stop background jobs"'
    command "cd #{fetch(:current_path)} && RAILS_ENV=#{fetch(:rails_env)} bin/delayed_job stop"
    command 'echo "done"'
  end

  task start: :environment do
    command 'echo "start background jobs"'
    command "cd #{fetch(:current_path)} && RAILS_ENV=#{fetch(:rails_env)} bin/delayed_job start"
    command 'echo "done"'
  end
end
