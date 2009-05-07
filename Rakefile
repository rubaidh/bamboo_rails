require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/clean'

spec = eval(File.read('bamboo_rails.gemspec'))
Rake::GemPackageTask.new(spec) do |t|
  t.need_tar = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files += ['README.rdoc', 'MIT-LICENSE', 'lib/bamboo_rails.rb']
end