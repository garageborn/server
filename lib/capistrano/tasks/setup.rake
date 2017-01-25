require ::File.expand_path('../../setup', __FILE__)

namespace :setup do
  desc 'Ask root keys'
  task :ask_root_keys do
    root_keys_path = File.expand_path('~/.ssh/garageborn.pem')
    raise "Please add your keys on #{ root_keys_path }" unless File.exist?(root_keys_path)
  end

  desc 'Reboot'
  task :reboot do
    on roles(:all) do
      execute(:sudo, :reboot) rescue nil
      puts 'Sleeping for 3 minutes (waiting for reboot)'
      sleep 180
    end
  end

  desc 'set a custom `/etc/ssh/sshd_config` to change the default port to `49151` and apply security policies'
  task :sshd do
    on roles(:all) do |host|
      with_default_user(host) do
        run_script('sshd.sh', use_sudo: true)
      end
    end
  end

  desc 'Remove default user'
  task :remove_default_user do
    on roles(:all) do
      run_script('remove_default_user.sh')
    end
  end

  desc 'Setup a new server'
  task :run do
    invoke 'setup:system:run'
    invoke 'setup:user:run'

    invoke 'setup:sshd'
    invoke 'setup:remove_default_user'

    invoke 'setup:tools:run'
    invoke 'setup:reboot'

    invoke 'deploy'

    puts 'Please add env variables on /etc/profile.f/garageborn.sh'
  end

  before 'setup:run', 'setup:ask_root_keys'
  Rake::Task['rbenv:validate'].clear
end
