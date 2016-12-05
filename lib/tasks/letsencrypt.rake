namespace :letsencrypt do
  DOMAINS = %w(
    alpha.mtt.rs
    alpha.br.mtt.rs
    api.mtt.rs
    www.garageborn.com
  ).freeze

  desc 'Renew all certs'
  task :renew do
    DOMAINS.each do |domain|
      Rake::Task['letsencrypt:generate:run'].invoke(domain)
    end
  end

  namespace :generate do
    task :run, [:domain] do |_t, args|
      domain = args[:domain]
      Rake::Task['letsencrypt:generate:create'].invoke(domain)
      Rake::Task['letsencrypt:generate:download'].invoke(domain)
      Rake::Task['letsencrypt:generate:commit'].invoke(domain)
    end

    desc 'Create cert'
    task :create, [:domain] do |_t, args|
      domain = args[:domain]
      command = <<-CMD
        /usr/bin/certbot certonly \
          --text \
          --non-interactive \
          --agree-tos \
          --email apps@garageborn.com \
          --webroot \
          -w /tmp/letsencrypt/#{ domain } \
          -d #{ domain }
      CMD
      system "docker exec -ti server_web_1 mkdir -p /tmp/letsencrypt/#{ domain }"
      system "docker exec -ti server_web_1 #{ command }"
    end

    desc 'Download created certs'
    task :download, [:domain] do |_t, args|
      domain = args[:domain]
      files = `docker exec -t server_web_1 ls /etc/letsencrypt/live/#{ domain }`.chomp.split
      files.each do |file|
        system <<-CMD
          docker cp --follow-link \
            server_web_1:/etc/letsencrypt/live/#{ domain }/#{ file } \
            docker/images/web/nginx/ssl/#{ domain }
        CMD
      end
    end

    desc 'Commit certs'
    task :commit, [:domain] do |_t, args|
      domain = args[:domain]
      system "git commit -a -m'#{ domain } certs created'"
    end
  end
end
