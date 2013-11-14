namespace :nginx do
  desc "Setup nginx configuration for this application"
  task :setup do
    on roles(:web) do |host|
      template "nginx_puma.erb", "/tmp/nginx_conf"
      template "service.erb", "/tmp/service_conf"
      on "#{fetch(:sudo_user)}@#{host}" do
        sudo "mv /tmp/nginx_conf /etc/nginx/sites-available/#{fetch(:application)}_#{fetch(:rails_env)}"
        sudo "mv /tmp/service_conf /etc/init/#{fetch(:application)}_#{fetch(:rails_env)}.conf"
      end
    end
  end

  task :disable do
    on roles(:web) do |host|
      on "#{fetch(:sudo_user)}@#{host}" do
        sudo "/usr/sbin/nxdissite #{fetch(:application)}_#{fetch(:rails_env)}"
      end
    end
  end 

  task :enable do
    on roles(:web) do |host|
      on "#{fetch(:sudo_user)}@#{host}" do
        sudo "/usr/sbin/nxensite #{fetch(:application)}_#{fetch(:rails_env)}"
      end
    end
  end

  %w[start stop restart reload].each do |command|
    desc "#{command} nginx"
    task command do
      on roles(:web) do |host|
        on "#{fetch(:sudo_user)}@#{host}" do
          sudo "/sbin/service nginx #{command}"
        end
      end
    end
  end

  after "nginx:setup", "nginx:enable"
  after "nginx:enable", "nginx:reload"
end