require ::File.expand_path('../../../setup', __FILE__)

namespace :setup do
  namespace :user do
    desc 'Setup user'
    task :run do
      invoke 'setup:user:create_user'
      invoke 'setup:user:ssh_keys'
      invoke 'setup:user:bashrc'

    end

    desc 'set bashrc variables'
    task :bashrc do
      on roles(:all) do
        with_default_user(host) do
          run_script('user/bashrc.sh')
        end
      end
    end

    desc 'create a new user named `gb` with sudo privileges'
    task :create_user do
      on roles(:all) do |host|
        with_default_user(host) do
          run_script('user/create_user.sh')
        end
      end
    end

    desc 'add SSH keys to `~/.ssh/authorized_keys`'
    task :ssh_keys do
      on roles(:all) do |host|
        with_default_user(host) do
          run_script('user/ssh_keys.sh')
        end
      end
    end
  end
end
