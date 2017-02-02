namespace :letsencrypt do
  # DOMAINS = %w(
  #   alpha.br.mtt.rs
  #   alpha.mtt.rs
  #   api.mtt.rs
  #   api.origin.mtt.rs
  #   www.garageborn.com
  # ).freeze
  DOMAINS = %w(api.origin.mtt.rs).freeze

  desc 'Renew all certs'
  task :renew do
    DOMAINS.each do |domain|
      invoke 'letsencrypt:generate:run', domain
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
      execute "mkdir -p /tmp/letsencrypt/#{ domain }"
      execute <<-CMD
        /usr/bin/certbot certonly \
          --text \
          --non-interactive \
          --agree-tos \
          --email apps@garageborn.com \
          --webroot \
          -w /tmp/letsencrypt/#{ domain } \
          -d #{ domain }
      CMD
      execute 'sudo chown garageborn:garageborn -R /etc/letsencrypt/'
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
    task :commit do |_t, domain|
      system "git commit -a -m'#{ domain } certs created'"
    end
  end
end
