require 'date'
require ::File.expand_path('../s3_upload', __FILE__)

class PostgresqlBackup
  attr_reader :db_host, :db_port, :db_username, :db_name, :db_password,
              :s3_bucket_name, :backup_path, :gzip_path

  def initialize(options)
    @db_host = options[:db_host]
    @db_port = options[:db_port]
    @db_username = options[:db_username]
    @db_name = options[:db_name]
    @db_password = options[:db_password]
    @s3_bucket_name = options[:s3_bucket_name]
    @backup_path = "/tmp/#{ db_name }-#{ Time.now.strftime('%Y%m%d%H%M%S') }.dump"
    @gzip_path = "#{ backup_path }.tar.gz"
  end

  def dump
    system <<-CMD
      export PGPASSWORD=#{ db_password }
      pg_dump -h #{ db_host } -p #{ db_port } -U #{ db_username } -W #{ db_name } --no-password > #{ backup_path }
    CMD
  end

  def gzip
    system <<-CMD
      tar -czf #{ gzip_path } #{ backup_path }
    CMD
  end

  def upload
    S3Upload.new(prefix: 'database', path: gzip_path, s3_bucket_name: s3_bucket_name).run!
  end

  def cleanup
    system <<-CMD
      rm -rf #{ backup_path } #{ gzip_path }
    CMD
  end

  def run!
    dump
    gzip
    puts upload
  ensure
    cleanup
  end
end
