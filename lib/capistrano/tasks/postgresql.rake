require 'uri'

namespace :postgresql do
  namespace :backup do
    desc 'Create a postgresql dump from skore'
    task :skore do
      on roles(:db) do
        within current_path do
          rake_output = capture(:bundle, :exec, :rake, 'postgresql_backup:skore')
          backup_uri = URI.parse(URI.extract(rake_output).last)

          output = "#{ fetch(:root) }/tmp/#{ File.basename(backup_uri.path) }"
          system <<-CMD
            wget "#{ backup_uri }" --output-document=#{ output }
          CMD
        end
      end
    end
  end
end
