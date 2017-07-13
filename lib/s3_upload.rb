require ::File.expand_path('../../config/environment', __FILE__)

class S3Upload
  attr_reader :prefix, :path, :s3_bucket_name, :expiry

  def initialize(options)
    Fog::Logger[:warning] = nil
    @prefix = options[:prefix]
    @path = options[:path]
    @s3_bucket_name = options[:s3_bucket_name]
    @expiry = options[:expiry] || 30.minutes.from_now
  end

  def connection
    @connection ||= Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    })
  end

  def bucket(prefix, s3_bucket_name)
    connection.directories.create(key: "#{ s3_bucket_name }/#{ prefix }")
  end

  def run!
    dir = bucket(prefix, s3_bucket_name)

    file = dir.files.create(
      key: File.basename(path),
      body: File.open(path)
    )
    puts file.url(expiry)
  end
end
