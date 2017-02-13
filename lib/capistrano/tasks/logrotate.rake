namespace :logrotate do
  namespace :setup do
    desc 'Setup logrotate'
    task :run do
      invoke 'logrotate:setup:config'
    end

    desc 'Symlink `config/logrotate/*.rotate` files'
    task :config do
      on roles(:all) do
        execute(:sudo, "cp -a #{ fetch(:release_path) }/config/logrotate/* /etc/logrotate.d")
        execute(:sudo, 'chown root:root /etc/logrotate.d/*.rotate')
        execute(:sudo, 'chmod 644 /etc/logrotate.d/*.rotate')
      end
    end
  end

  after :deploy, 'logrotate:setup:run'
end
