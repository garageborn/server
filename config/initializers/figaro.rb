Figaro.application = Figaro::Application.new(
  path: ::File.expand_path('../../application.yml', __FILE__)
)
Figaro.load
