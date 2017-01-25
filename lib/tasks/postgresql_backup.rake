require ::File.expand_path('../../postgresql_backup', __FILE__)

namespace :postgresql do
  desc 'Postgreql backup'
  task :backup do
    PostgresqlBackup.new(
      db_name: ENV['DB_NAME'],
      db_host: ENV['DB_HOSTNAME'],
      db_port: ENV['DB_PORT'],
      db_username: ENV['DB_USERNAME'],
      db_password: ENV['DB_PASSWORD'],
      s3_bucket_name: ENV['S3_BUCKET_NAME']
    ).run!
  end
end
