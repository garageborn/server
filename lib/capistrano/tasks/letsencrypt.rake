namespace :letsencrypt do
  # DOMAINS = %w(
  #   mtt.rs
  #   mttrs.com.br
  #   api.mtt.rs
  #   api.origin.mtt.rs
  #   www.garageborn.com
  # ).freeze

  DOMAINS = %w(
  mttrs.com.br
  ).freeze

  desc 'Renew all certs'
  task :renew do
    DOMAINS.each do |domain|
      invoke 'letsencrypt:generate:run', domain
      Rake::Task['letsencrypt:generate:run'].reenable
      Rake::Task['letsencrypt:generate:create'].reenable
      Rake::Task['letsencrypt:generate:download'].reenable
      Rake::Task['letsencrypt:generate:commit'].reenable
    end
  end

  namespace :generate do
    task :run, :domain do |_t, args|
      domain = args[:domain]
      invoke 'letsencrypt:generate:create', domain
      invoke 'letsencrypt:generate:download', domain
      invoke 'letsencrypt:generate:commit', domain
    end

    desc 'Create cert'
    task :create, :domain do |_t, args|
      domain = args[:domain]
      on roles(:ssl) do
        execute <<-CMD
          mkdir -p /tmp/letsencrypt/#{ domain }
          sudo chown -R garageborn:garageborn /var/log/letsencrypt /etc/letsencrypt/
          letsencrypt certonly \
            --text \
            --non-interactive \
            --agree-tos \
            --email apps@garageborn.com \
            --webroot \
            -w /tmp/letsencrypt/#{ domain } \
            -d #{ domain }
        CMD
      end
    end

    desc 'Download created certs'
    task :download, :domain do |_t, args|
      domain = args[:domain]
      origin = "/etc/letsencrypt/live/#{ domain }"
      destination = File.expand_path("../../../../config/nginx/ssl/", __FILE__)
      system "mkdir -p #{ destination }"

      on roles(:ssl) do
        download!(origin, destination, recursive: true)
      end
    end

    desc 'Commit certs'
    task :commit do |_t, args|
      domain = args[:domain]
      system "git add . && git commit -a -m'#{ domain } certs created'"
    end
  end
end
