require 'rake'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/clean'
require 'rubyforge'
require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new

spec = eval(File.read('bamboo_rails.gemspec'))
Rake::GemPackageTask.new(spec) do |t|
  t.need_tar = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files += ['README.rdoc', 'CHANGELOG', 'MIT-LICENSE', 'lib/bamboo_rails.rb']
end

desc "Package and upload the release to RubyForge"
task :release => [:clobber, :package] do
  rubyforge = RubyForge.new.configure
  rubyforge.login
  rubyforge.add_release spec.rubyforge_project, spec.name, spec.version.to_s, "pkg/#{spec.name}-#{spec.version}.gem"
end