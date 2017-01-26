require 'uri'

namespace :postgresql do
  desc 'Create a postgresql dump'
  task :backup do
    on roles(:db) do
      within current_path do
        rake_output = capture(:bundle, :exec, :rake, 'postgresql:backup')
        backup_uri = URI.parse(URI.extract(rake_output).last)

        output = "#{ fetch(:root) }/tmp/#{ File.basename(backup_uri.path) }"
        system <<-CMD
          wget "#{ backup_uri }" --output-document=#{ output }
        CMD
      end
    end
  end
end
