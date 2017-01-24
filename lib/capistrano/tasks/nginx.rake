namespace :nginx do
  namespace :setup do
    desc 'Setup nginx'
    task :run do
      invoke 'nginx:setup:config'
      invoke 'nginx:setup:set_permissions'
      invoke 'nginx:restart'
    end

    desc 'Install Nginx config files from `config/nginx`'
    task :config do
      on roles(:all) do
        execute(:sudo, 'rm -rf /etc/nginx.bkp')
        execute(:sudo, 'mv -f /etc/nginx /etc/nginx.bkp 2>/dev/null') rescue nil
        execute(:sudo, 'rm -rf /etc/nginx')
        execute(:sudo, "cp -a #{ fetch(:release_path) }/config/nginx /etc/nginx")
      end
    end

    desc 'Allow `garageborn` user to write Nginx logs'
    task :set_permissions do
      on roles(:all) do
        execute :sudo, :mkdir, '-p', '/var/log/nginx/'
        execute :sudo, :chown, '-Rf', 'garageborn:garageborn', '/var/log/nginx/'
      end
    end
  end

  desc 'Stop Nginx'
  task :stop do
    on roles(:all) do
      execute(:sudo, 'nginx -s stop') rescue nil
    end
  end

  desc 'Start Nginx'
  task :start do
    on roles(:all) do
      execute(:sudo, 'nginx')
    end
  end

  desc 'Restart Nginx'
  task :restart do
    invoke 'nginx:stop'
    invoke 'nginx:start'
  end

  after :deploy, 'nginx:setup:run'
end
