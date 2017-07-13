require 'active_support/all'
require 'figaro'
require 'fog'
require 'byebug'
require 'aws-sdk'

Dir.glob(File.expand_path('../initializers/**/*.rb', __FILE__)).each { |f| require f }
Dir.glob(File.expand_path('../../lib/*.rb', __FILE__)).each { |f| require f }
Dir.glob(File.expand_path('../../lib/**/*.rb', __FILE__)).each { |f| require f }
