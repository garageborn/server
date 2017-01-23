require ::File.expand_path('../../../setup', __FILE__)

namespace :setup do
  namespace :tools do
    desc 'Setup tools'
    task :run do
      invoke 'setup:tools:ruby'
      invoke 'setup:tools:node'
      invoke 'setup:tools:nginx'
    end

    desc 'Install node'
    task :node do
      on roles(:all) do
        run_script('tools/node.sh')
      end
    end

    desc 'Install ruby'
    task :ruby do
      on roles(:all) do
        run_script('tools/ruby.sh')
      end
    end

    desc 'Install nginx'
    task :nginx do
      on roles(:all) do
        run_script('tools/nginx.sh')
      end
    end
  end
end
