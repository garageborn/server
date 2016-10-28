namespace :deploy do
  desc 'Load aws login'
  task :setup do
    system "eval `aws ecr get-login`"
  end

  desc 'Publish application'
  task :publish do
    system "#{ docker_compose } pull"
    system "#{ docker_compose } build"
    system "#{ docker_compose } up -d --remove-orphans"
  end

  desc 'Cleanup unused images'
  task :cleanup do
    system "#{ docker } rmi $(#{ docker } images --filter 'dangling=true' -q --no-trunc)"
  end

  task :run do
    Rake::Task['deploy:setup'].invoke
    Rake::Task['deploy:publish'].invoke
    Rake::Task['deploy:cleanup'].invoke
  end
end

desc 'Deploy'
task :deploy do
  Rake::Task['deploy:run'].invoke
end

def docker
  "docker #{ docker_params }"
end

def docker_compose
  "docker-compose #{ docker_params }"
end

def docker_params
  env = `docker-machine --storage-path docker/machine env app.production`
  host = env.scan(/tcp:\/\/.*\:2376/).first
  command = <<-CMD
      --tlsverify \
      --tlscacert docker/machine/machines/app.production/ca.pem \
      --tlscert docker/machine/machines/app.production/cert.pem \
      --tlskey docker/machine/machines/app.production/key.pem \
      --host #{ host }
  CMD
  command.chomp
end
