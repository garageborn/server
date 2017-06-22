namespace :letsencrypt do
  DOMAINS = %w(
    api.mtt.rs
    api.origin.mtt.rs
    ar.mtt.rs
    ar.origin.mtt.rs
    cl.mtt.rs
    cl.origin.mtt.rs
    mtt.rs
    origin.mtt.rs
    mttrs.com.br
    origin.mttrs.com.br
    mx.mtt.rs
    mx.origin.mtt.rs
    www.garageborn.com
  ).freeze

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
