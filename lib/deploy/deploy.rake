namespace :deploy do
  desc 'Load aws login'
  task :setup do
    system "eval `aws ecr get-login`"
  end

  desc 'Publish application'
  task :publish do
    system "#{ compose_command } up -d --force-recreate --remove-orphans"
  end

  task :run do
    Rake::Task['deploy:setup'].invoke
    Rake::Task['deploy:publish'].invoke
  end
end

desc 'Deploy'
task :deploy do
  Rake::Task['deploy:run'].invoke
end

def compose_command
  env = `docker-machine --storage-path docker/machine env app.production`
  host = env.scan(/tcp:\/\/.*\:2376/).first
  command = <<-CMD
    docker-compose \
      --tlsverify \
      --tlscacert docker/machine/machines/app.production/ca.pem \
      --tlscert docker/machine/machines/app.production/cert.pem \
      --tlskey docker/machine/machines/app.production/key.pem \
      --host #{ host }
  CMD
  command.chomp
end
