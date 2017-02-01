lock '3.7.2'

set :application, 'server'
set :repo_url, 'git@github.com:garageborn/server.git'
set :keep_releases, 10
set :deploy_to, '/home/garageborn/server'
set :pty, true
set :root, File.expand_path(File.dirname(__FILE__) + '/../')
set :ssh_options, forward_agent: true, port: 41_858
set :branch, -> { ENV['branch'] || `git rev-parse --abbrev-ref HEAD`.chomp }
set :use_sudo, false

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{ fetch(:rbenv_path) } RBENV_VERSION=#{ fetch(:rbenv_ruby) } #{ fetch(:rbenv_path) }/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

# slackistrano
set :slackistrano,
  channel: '#activities',
  webhook: 'https://hooks.slack.com/services/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'
