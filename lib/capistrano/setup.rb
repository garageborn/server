def run_script(script, use_sudo: false, args: nil)
  sudo = 'sudo' if use_sudo
  filename = script.split('/').last
  basepath = '/tmp/setup'

  execute("sudo mkdir -p #{ basepath }")
  execute("sudo mkdir -p chown `whoami`:`whoami` #{ basepath }")

  upload!("#{ fetch(:root) }/config/setup/#{ script }", basepath)
  execute("#{ sudo } chmod +x #{ basepath }/#{ filename }")
  execute("cd #{ basepath } && #{ sudo } ./#{ filename } #{ args }")
end

def with_default_user(host, &block)
  host.user = 'ubuntu'
  host.ssh_options = {
    auth_methods: %w(publickey),
    forward_agent: true,
    port: 22,
    keys: [File.expand_path('~/.ssh/garageborn.pem')]
  }
  block.call
end
