namespace :nginx do
  desc "Setup nginx configuration for this application"
  task :setup do
    on roles(:web) do |host|
      template "nginx_puma.erb", "/tmp/nginx_conf"
      on "#{fetch(:sudo_user)}@#{host}" do
        sudo "mv /tmp/nginx_conf /etc/nginx/sites-available/#{fetch(:application)}"
        sudo "/usr/sbin/nxensite #{fetch(:application)}"
        sudo "rm -f /etc/nginx/conf.d/default"      
      end
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command do
      on roles(:web) do |host|
        on "#{fetch(:sudo_user)}@#{host}" do
          sudo "/sbin/service nginx #{command}"
        end
      end
    end
  end

  after "nginx:setup", "nginx:restart"
end