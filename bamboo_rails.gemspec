spec = Gem::Specification.new do |s|

  s.name     = 'bamboo_rails'
  s.version  = '0.99.0'
  s.date     = '2009-05-06'
  s.authors  = ['Graeme Mathieson', 'Rubaidh Ltd']
  s.email    = 'support@rubaidh.com'
  s.has_rdoc = false
  s.homepage = 'http://github.com/rubaidh/bamboo_rails'
  s.summary  = 'A bit of assistance for using Bamboo in your Rails applications'

  s.description = "This Rails gem/plugin just contains a couple of tasks "  +
    "that make life easier when dealing with the Atlassian Bamboo "         +
    "Continuous Integration Server. All it does is to create a rake task, " +
    "+bamboo+, which will run your full test suite (be it Cucumber, RSpec " +
    "or Test::Unit) and use the +ci_reporter+ gem to format the results "   +
    "in a manner that Bamboo will happily consume."

  s.files = %w(
    bamboo_rails.gemspec MIT-LICENSE README
    tasks/bamboo_rails_tasks.rake
  )

  # 1.6.0 is the first version that has cucumber support.
  s.add_dependency 'ci_reporter', '>=1.6.0'
end
