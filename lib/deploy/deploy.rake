namespace :deploy do
  desc 'Load aws login'
  task :setup do
    # puts `docker-machine --storage-path docker/machine env app.production`
    # puts `eval $(docker-machine --storage-path docker/machine env app.production)`
    puts `docker-compose ps`
    system <<-CMD
      eval `aws ecr get-login`
      eval $(docker-machine --storage-path docker/machine env app.production)
    CMD
  end

  desc 'Publish application'
  task :publish do
    system 'docker-compose up -d --force-recreate --remove-orphans'
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
