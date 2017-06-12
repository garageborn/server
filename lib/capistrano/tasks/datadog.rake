namespace :datadog do
  desc 'Stop datadog'
  task :stop do
    on roles(:app) do
      execute(:sudo, '/etc/init.d/datadog-agent stop') rescue nil
    end
  end

  desc 'Start datadog'
  task :start do
    on roles(:app) do
      execute(:sudo, '/etc/init.d/datadog-agent start')
    end
  end

  desc 'Restart datadog'
  task :restart do
    on roles(:app) do
      execute(:sudo, '/etc/init.d/datadog-agent restart')
    end
  end
end
