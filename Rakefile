require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "wriggle"
    gem.summary = %Q{A simple directory crawler DSL.}
    gem.description = %Q{A simple directory crawler DSL.}
    gem.email = "rspeicher@gmail.com"
    gem.homepage = "http://github.com/tsigo/wriggle"
    gem.authors = ["Robert Speicher"]
    gem.add_development_dependency "rspec", "~> 2.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
