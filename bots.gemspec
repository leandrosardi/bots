Gem::Specification.new do |s|
  s.name        = 'bots'
  s.version     = '1.0.1'
  s.date        = '2023-08-08'
  s.summary     = "Ruby gem for scraping information from the public web."
  s.description = "Ruby gem for scraping information from the public web."
  s.authors     = ["Leandro Daniel Sardi"]
  s.email       = 'leandro@connectionsphere.com'
  s.files       = [
    'lib/bots.rb',
    'lib/base.rb',
    'lib/google.rb',
    'lib/indeed.rb',
  ]
  s.homepage    = 'https://rubygems.org/gems/bots'
  s.license     = 'MIT'
  s.add_runtime_dependency 'simple_cloud_logging', '~> 1.2.2', '>= 1.2.2'
  s.add_runtime_dependency 'csv', '~> 3.2.7', '>= 3.2.7'
  s.add_runtime_dependency 'mechanize', '~> 2.8.5', '>= 2.8.5'
  s.add_runtime_dependency 'selenium-webdriver', '~> 4.10.0', '>= 4.10.0'
  s.add_runtime_dependency 'colorize', '~> 0.8.1', '>= 0.8.1'
end