namespace :deploy do
  desc 'Load aws login'
  task :setup do
    system <<-CMD
      eval `aws ecr get-login`
      eval $(docker-machine --storage-path docker/machine env app.production)
    CMD
  end

  desc 'Publish application'
  task :publish do
    system 'docker-compose up -d'
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

Dir.glob('lib/deploy/tasks/*.rake').each { |r| load r }