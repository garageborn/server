require ::File.expand_path('../../../setup', __FILE__)

namespace :setup do
  namespace :user do
    desc 'Setup user'
    task :run do
      invoke 'setup:create_user'
      invoke 'setup:user_ssh'
      invoke 'setup:bashrc'
      invoke 'setup:remove_default_user'
    end

    desc 'set bashrc variables'
    task :bashrc do
      on roles(:all) do
        run_script('user/bashrc.sh')
      end
    end

    desc 'create a new user named `gb` with sudo privileges'
    task :create_user do
      on roles(:all) do |host|
        with_default_user(host) do
          run_script('user/create_user.sh', use_sudo: true)
        end
      end
    end

    desc 'add SSH keys to `~/.ssh/authorized_keys`'
    task :user_ssh do
      on roles(:all) do |host|
        with_default_user(host) do
          run_script('user/user_ssh.sh', use_sudo: true)
        end
      end
    end

    desc 'Remove default user'
    task :remove_default_user do
      on roles(:all) do
        run_script('user/remove_default_user.sh')
      end
    end
  end
end
