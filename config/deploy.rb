require 'mina/bundler'
require 'mina/puma'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :rails_env, 'production'
set :application_name, 'hairfolio'
set :domain, ENV['DOMAIN']
set :deploy_to, '/var/www/html/hairfolio'
#set :repository, 'git@bitbucket.org:krupa_suthar_agile/hairfolio_api_v2.git'
set :repository, 'git@bitbucket.org:praveen_agile/hairfolio_api_v2.git'
set :branch, 'production'
set :user, ENV['DEPLOY_USER']
# set :current_path, 'current'
set :shared, 'shared'

#set :rbenv_map_bins, %w{rake gem bundle ruby rails puma pumactl}

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
#set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/uploads','tmp/log', 'public')
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'tmp/log')
set :shared_files, fetch(:shared_files, []).push('config/master.key','config/puma.rb','config/database.yml')

#set :puma_bind,       "unix://#{fetch(:shared)}/tmp/sockets/#{fetch(:application_name)}-puma.sock"
#set :puma_state,      "#{fetch(:shared)}/tmp/pids/puma.state"
#set :puma_pid,        "#{fetch(:shared)}/tmp/pids/puma.pid"
#set :puma_access_log, "#{fetch(:shared)}/log/puma.error.log"
#set :puma_error_log,  "#{fetch(:shared)}/log/puma.access.log"
#set :pumactl_socket, "#{fetch(:shared)}/tmp/sockets/#{fetch(:application_name)}-puma.sock"
#set :puma_socket, "#{fetch(:shared)}/tmp/sockets/#{fetch(:application_name)}-puma.sock"
# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end


# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task setup: :environment do
  command %[mkdir -p "#{fetch(:deploy_to)}/shared/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/log"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/config"]

  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp/sockets"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/sockets"]
  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/pids"]
  command %[mkdir -p "#{fetch(:deploy_to)}/shared/tmp/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/log"]
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    comment "Deploying to #{fetch(:application_name)} to #{fetch(:domain)}: #{fetch(:deploy_to)}"
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
        invoke :'puma:phased_restart'
        # invoke :'puma_restart'
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# task puma_start: :remote_environment do
#   command %[
#     if [ -e '#{fetch(:puma_pid)}' ]; then
#       echo 'Puma is already running'
#     else
#       echo 'Start Puma'
#       cd #{fetch(:current_path)} && bundle exec puma -q -d -e #{fetch(:rails_env)} -C #{fetch(:current_path)}/config/puma.rb -p #{fetch(:start_port)} -S #{fetch(:puma_state)} -b "unix://#{fetch(:puma_socket)}" --pidfile #{fetch(:puma_pid)}
#     fi
#   ]
# end
#
# task puma_restart: :remote_environment do
#   command %[
#     if [ -e '#{fetch(:puma_pid)}' ]; then
#       echo 'Restart Puma'
#       cd #{fetch(:current_path)} && bundle exec pumactl -S #{fetch(:puma_state)} restart
#     else
#       echo 'Start Puma'
#       cd #{fetch(:current_path)} && bundle exec puma -q -d -e #{fetch(:rails_env)} -C #{fetch(:current_path)}/config/puma.rb -p #{fetch(:start_port)} -S #{fetch(:puma_state)} -b "unix://#{fetch(:puma_socket)}" --pidfile #{fetch(:puma_pid)}
#     fi
#   ]
# end
#
# task puma_stop: :remote_environment do
#   command %[
#     if [ -e '#{fetch(:puma_pid)}' ]; then
#       cd #{fetch(:current_path)} && bundle exec pumactl -S #{fetch(:puma_state)} stop
#       rm #{fetch(:puma_socket)}
#       rm #{fetch(:puma_state)}
#       rm #{fetch(:puma_pid)}
#     else
#       echo 'Puma is not running. Phew!!!'
#     fi
#   ]
# end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
