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
      puts 'Sleeping for 5 minutes (waiting for reboot)'
      sleep 300
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

  desc 'Setup a new server'
  task :run do
    invoke 'setup:system:run'
    invoke 'setup:user:run'
    invoke 'setup:sshd'
    invoke 'setup:tools:run'
    invoke 'setup:reboot'

    invoke 'deploy'
  end

  before 'setup:run', 'setup:ask_root_keys'
  Rake::Task['rbenv:validate'].clear
end
