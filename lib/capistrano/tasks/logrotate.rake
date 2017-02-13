namespace :logrotate do
  namespace :setup do
    desc 'Setup logrotate'
    task :run do
      invoke 'logrotate:setup:config'
    end

    desc 'Symlink `config/logrotate/*.rotate` files'
    task :config do
      on roles(:all) do
        execute(:sudo, "cp -a #{ fetch(:release_path) }/config/logrotate /etc/logrotate.d")
      end
    end
  end

  after :deploy, 'logrotate:setup:run'
end
