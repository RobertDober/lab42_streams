$:.unshift( File.expand_path( "../lib", __FILE__ ) )
require 'lab42/stream/version'
version = Lab42::Stream::Version
Gem::Specification.new do |s|
  s.name        = 'lab42_streams'
  s.version     = version
  s.summary     = "Streams for Ruby 2.0"
  s.description = %{Lazy Evaluation, Streams, Enumerator#Lazy}
  s.authors     = ["Robert Dober"]
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob("lib/**/*.rb")
  s.files      += %w{LICENSE README.md}
  s.homepage    = "https://github.com/RobertDober/lab42_streams"
  s.licenses    = %w{MIT}

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency 'forwarder2', '~> 0.2.0'
  s.add_dependency 'lab42_core', '~> 0.0.5'

  s.add_development_dependency 'pry', '~> 0.9.12'
  s.add_development_dependency 'pry-nav', '~> 0.2'
  s.add_development_dependency 'rspec', '~> 2.14.0'
  s.add_development_dependency 'qed', '~> 2.9'
  s.add_development_dependency 'ae', '~> 1.8'
  s.add_development_dependency 'byebug', '~> 3.1'
end
