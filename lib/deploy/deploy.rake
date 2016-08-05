namespace :deploy do
  def compose_command
    <<-CMD
      docker-compose \
        --tls \
        --tlscacert docker/machine/machines/app.production/ca.pem \
        --tlscert docker/machine/machines/app.production/cert.pem \
        --tlskey docker/machine/machines/app.production/key.pem \
        --host tcp://52.20.45.85:2376 \
    CMD
  end

  desc 'Load aws login'
  task :setup do
    puts `docker-compose ps`
    system <<-CMD
      eval `aws ecr get-login`
      eval $(docker-machine --storage-path docker/machine env app.production)
    CMD
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
