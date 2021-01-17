# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

set :application, "quiet-dawn-5173"
set :repo_url, "git@github.com:thaleshcv/quiet-dawn-5173.git"
set :branch, "main"
set :deploy_to, "/home/ubuntu/#{fetch :application}"
set :rvm_type, :auto
set :rvm_ruby_version, "2.6.5"
set :rvm_custom_path, "/usr/share/rvm"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", ".bundle", "public/system", "public/uploads"
set :keep_releases, 2

set :default_env, {
  PATH: "$HOME/node-v10.23.1-linux-x64/bin:$PATH",
  NODE_ENVIRONMENT: "production"
}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
