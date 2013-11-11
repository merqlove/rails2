set :application, 'rails2'

set :user, 'merkulov'
set :ssh_options, {port: 2222, keys: ['~/.ssh/id_rsa_digitalocean_merkulov']}

set :default_environment, {
  'PATH' => '/opt/rbenv/shims:/opt/rbenv/bin:$PATH',
  'RBENV_ROOT' => '/opt/rbenv'
}

set :scm, :git
set :repo_url, 'git@github.com:merqlove/rails2.git'
set :branch, :master
set :deploy_via, :remote_cache

set :bundle_flags, '--deployment --quiet --binstubs --shebang ruby-local-exec'

# default_run_options[:pty] = true
# ssh_options[:forward_agent] = true


# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5





# before :bundle, 'custom:rbenv_version'
# after 'deploy:updating', 'custom:file_system'
after 'deploy:finishing', 'deploy:cleanup'
after 'deploy:finishing', 'puma:restart'