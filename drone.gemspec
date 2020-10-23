require_relative 'lib/drone/version'

Gem::Specification.new do |s|
  s.name        = 'drone'
  s.version     = Drone::VERSION
  s.summary     = 'Drone'
  s.description = 'Fly a Quadcopter Drone'
  s.homepage    = 'https://github.com/dsadaka/drone'
  s.author      = 'Dan Sadaka'
  s.email       = 'dan@web-site1.com'
  s.files = Dir.glob('lib/**/*')
  s.executables << 'drone'
end
