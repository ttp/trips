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

set :domain,      '128.199.40.129'
set :user,        'rails'
set :repository,  'git@github.com:ttp/trips.git'
set :branch,      'master'
set :deploy_to,   '/home/rails/www/pohody.com.ua'
set :app_path,    "#{deploy_to}/#{current_path}"
set :rails_env,   'production'
set :keep_releases, 5

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, [
  'log',
  'tmp',
  'config/database.yml',
  'config/environments/production.rb',
  'config/secrets.yml',
  'config/initializers/devise.rb',
  'public/system',
  'public/media'
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
  invoke :'rvm:use[ruby-2.1.5@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task setup: :environment do
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/log")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/config")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/config/initializers")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config/initializers")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/config/environments")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config/environments")

  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/public/system")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/system")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/public/media")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/public/media")

  queue! %(touch "#{deploy_to}/#{shared_path}/config/database.yml")
  queue! %(touch "#{deploy_to}/#{shared_path}/config/secrets.yml")
  queue! %(touch "#{deploy_to}/#{shared_path}/config/environments/production.rb")
  queue! %(touch "#{deploy_to}/#{shared_path}/config/initializers/devise.rb")
  queue %(echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config*'.")
end

desc 'Deploys the current version to the server.'
task deploy: :environment do
  deploy do
    to :prepare do
    end

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'passenger:restart'
    end
  end
end

desc 'Seed data to the database'
task seed: :environment do
  queue "cd #{deploy_to}/#{current_path}/"
  queue "bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  queue %(echo "-----> Rake Seeding Completed.")
end

namespace :unicorn do
  set :unicorn_pid, "#{app_path}/tmp/pids/unicorn.pid"
  set :start_unicorn, %(
    cd #{app_path}
    bundle exec unicorn -c #{app_path}/config/unicorn.rb -E #{rails_env} -D
    )

  # Start task
  # ------------------------------------------------------------------------------
  desc 'Start unicorn'
  task start: :environment do
    queue 'echo "-----> Start Unicorn"'
    queue! start_unicorn
  end

  # Stop task
  # ------------------------------------------------------------------------------
  desc 'Stop unicorn'
  task :stop do
    queue 'echo "-----> Stop Unicorn"'
    queue! %(
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
    queue "touch #{app_path}/tmp/restart.txt"
  end
end

namespace :jobs do
  task stop: :environment do
    queue 'echo "stop background jobs"'
    queue "cd #{app_path} && RAILS_ENV=#{rails_env} bin/delayed_job stop"
    queue 'echo "done"'
  end

  task start: :environment do
    queue 'echo "start background jobs"'
    queue "cd #{app_path} && RAILS_ENV=#{rails_env} bin/delayed_job start"
    queue 'echo "done"'
  end
end
