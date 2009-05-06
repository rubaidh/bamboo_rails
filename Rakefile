require 'rake'
require 'rake/gempackagetask'

spec = eval(File.read('bamboo_rails.gemspec'))
Rake::GemPackageTask.new(spec) do |t|
  t.need_tar = false
end