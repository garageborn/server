namespace :letsencrypt do
  # DOMAINS = %w(
  #   api.mtt.rs
  #   api.origin.mtt.rs
  #   argentina.mtt.rs
  #   argentina.origin.mtt.rs
  #   australia.mtt.rs
  #   australia.origin.mtt.rs
  #   chile.mtt.rs
  #   chile.origin.mtt.rs
  #   estadosunidos.mtt.rs
  #   estadosunidos.origin.mtt.rs
  #   mexico.mtt.rs
  #   mexico.origin.mtt.rs
  #   mtt.rs
  #   mttrs.com.br
  #   origin.mtt.rs
  #   origin.mttrs.com.br
  #   portugal.mtt.rs
  #   portugal.origin.mtt.rs
  #   www.garageborn.com
  # ).freeze

  DOMAINS = %w(
    australia.origin.mtt.rs
    chile.origin.mtt.rs
    estadosunidos.origin.mtt.rs
    mexico.origin.mtt.rs
    portugal.origin.mtt.rs
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
