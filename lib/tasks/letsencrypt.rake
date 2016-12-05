namespace :letsencrypt do
  DOMAINS = %w(
    alpha.br.mtt.rs
    alpha.mtt.rs
    api.mtt.rs
    www.garageborn.com
  ).freeze

  desc 'Renew all certs'
  task :renew do
    DOMAINS.each do |domain|
      Rake::Task['letsencrypt:generate:run'].execute(domain)
    end
  end

  namespace :generate do
    task :run do |_t, domain|
      Rake::Task['letsencrypt:generate:create'].execute(domain)
      Rake::Task['letsencrypt:generate:download'].execute(domain)
      Rake::Task['letsencrypt:generate:commit'].execute(domain)
    end

    desc 'Create cert'
    task :create do |_t, domain|
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
    task :download do |_t, domain|
      origin = "/etc/letsencrypt/live/#{ domain }"
      destination = File.expand_path("../../../docker/images/web/nginx/ssl/#{ domain }", __FILE__)
      system "mkdir -p #{ destination }"

      files = `docker exec -t server_web_1 ls #{ origin }`.chomp.split
      files.each do |file|
        system <<-CMD
          docker cp --follow-link server_web_1:#{ origin }/#{ file } #{ destination }
        CMD
      end
    end

    desc 'Commit certs'
    task :commit do |_t, domain|
      # system "git commit -a -m'#{ domain } certs created'"
    end
  end
end
