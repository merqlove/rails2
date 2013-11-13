set :application, 'rails2'

set :default_environment, {
  'PATH' => '/opt/rbenv/shims:/opt/rbenv/bin:$PATH',
  'RBENV_ROOT' => '/opt/rbenv'
}

set :ssh_options, {
  port: 22, 
  # verbose: :info,
  keys: %w(/Users/mrcr/.ssh/id_rsa_digitalocean),
  forward_agent: false,
  auth_methods: %w(publickey)
}

set :user, 'merkulov'

set :scm, :git
set :repo_url, 'git@github.com:merqlove/rails2.git'
set :branch, :master
set :deploy_via, :remote_cache

set :bundle_flags, '--deployment --quiet'
set :bundle_binstubs, -> { shared_path.join('.bundle/bin') }
set :bundle_dir, -> { shared_path.join('vendor/bundle') }

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :format, :pretty
set :log_level, :info
set :pty, false

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin .bundle log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5


task :whoami do
  on roles(:all) do
    execute :whoami
  end
end


# before :bundle, 'custom:rbenv_version'
after 'deploy:updating', 'custom:file_system'
after 'deploy:finishing', 'deploy:cleanup'
after 'deploy:cleanup', 'puma:restart'