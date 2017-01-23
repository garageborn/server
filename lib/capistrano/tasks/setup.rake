namespace :setup do
  def run_script(script, use_sudo: false, args: nil)
    sudo = 'sudo' if use_sudo
    upload!("#{ fetch(:root) }/config/setup/#{ script }", '/tmp')
    execute("#{ sudo } chmod +x /tmp/#{ script }")
    execute("cd /tmp && #{ sudo } ./#{ script } #{ args }")
  end

  def with_default_user(host, &block)
    host.user = 'ubuntu'
    host.ssh_options = {
      auth_methods: %w(publickey),
      forward_agent: true,
      port: 22,
      keys: [File.expand_path('~/.ssh/garageborn.pem')]
    }
    block.call
  end

  desc 'Install all packages'
  task :apt do
    on roles(:all) do
      run_script('apt.sh')
    end
  end

  desc 'Ask root keys'
  task :ask_root_keys do
    root_keys_path = File.expand_path('~/.ssh/garageborn.pem')
    raise "Please add your keys on #{ root_keys_path }" unless File.exist?(root_keys_path)
  end

  desc 'set bashrc variables'
  task :bashrc do
    on roles(:all) do
      run_script('bashrc.sh')
    end
  end

  desc 'create a new user named `gb` with sudo privileges'
  task :create_user do
    on roles(:all) do |host|
      with_default_user(host) do
        run_script('create_user.sh', use_sudo: true)
      end
    end
  end

  desc 'Setup hostname'
  task :hostname do
    on roles(:all) do |host|
      hostname = host.hostname.gsub('.server.garageborn.com', '').strip
      run_script('hostname.sh', args: hostname)
    end
  end

  desc 'Setup locale'
  task :locale do
    on roles(:all) do
      run_script('locale.sh')
    end
  end

  desc 'Remove default user'
  task :remove_default_user do
    on roles(:all) do
      run_script('remove_default_user.sh')
    end
  end

  desc 'Install ruby'
  task :ruby do
    on roles(:all) do
      run_script('ruby.sh')
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

  desc 'Change the timezone to `America/Sao_Paulo`'
  task :timezone do
    on roles(:all) do
      run_script('timezone.sh')
    end
  end

  desc 'add SSH keys to `~/.ssh/authorized_keys`'
  task :user_ssh do
    on roles(:all) do |host|
      with_default_user(host) do
        run_script('user_ssh.sh', use_sudo: true)
      end
    end
  end

  desc 'Setup a new server'
  task :run do
    # invoke 'setup:create_user'
    # invoke 'setup:user_ssh'
    # invoke 'setup:sshd'
    # invoke 'setup:remove_default_user'
    invoke 'setup:bashrc'
    #
    # invoke 'setup:apt'
    # invoke 'setup:ruby'
    #
    # invoke 'setup:hostname'
    # invoke 'setup:locale'
    # invoke 'setup:timezone'
    #
    # execute(:sudo, :reboot) rescue nil
    # puts 'Sleeping for 5 minutes (waiting for reboot)'
    # sleep 300
    #
    # invoke 'deploy'
  end

  before 'setup:run', 'setup:ask_root_keys'
  Rake::Task['rbenv:validate'].clear
end
