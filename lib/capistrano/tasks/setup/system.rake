require ::File.expand_path('../../../setup', __FILE__)

namespace :setup do
  namespace :system do
    desc 'Setup system'
    task :run do
      invoke 'setup:system:apt'
      invoke 'setup:system:hostname'
      invoke 'setup:system:locale'
      invoke 'setup:system:timezone'
    end

    desc 'Install all packages'
    task :apt do
      on roles(:all) do
        with_default_user(host) do
          run_script('system/apt.sh')
        end
      end
    end

    desc 'Setup hostname'
    task :hostname do
      on roles(:all) do |host|
        with_default_user(host) do
          hostname = host.hostname.gsub('.garageborn.com', '').strip
          run_script('system/hostname.sh', args: hostname)
        end
      end
    end

    desc 'Setup locale'
    task :locale do
      on roles(:all) do |host|
        with_default_user(host) do
          run_script('system/locale.sh')
        end
      end
    end

    desc 'Change the timezone to `America/Sao_Paulo`'
    task :timezone do
      on roles(:all) do
        with_default_user(host) do
          run_script('system/timezone.sh')
        end
      end
    end
  end
end
