require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "grove"
    gem.summary = "Invoke DRb services with no configuration"
    gem.email = "bagilevi@gmail.com"
    gem.homepage = "http://github.com/bagilevi/grove"
    gem.authors = [ "Levente Bagi" ]
    gem.version = "0.1"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'differ'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end

task :default => :test

