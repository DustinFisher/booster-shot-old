# -*- encoding: utf-8 -*-
# stub: given_core 3.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "given_core"
  s.version = "3.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jim Weirich"]
  s.date = "2016-01-14"
  s.description = "Given_core is the basic functionality behind rspec-given and minitest-given,\nextensions that allow the use of Given/When/Then terminology when defining\nspecifications.\n"
  s.email = "jim.weirich@gmail.com"
  s.homepage = "http://github.com/rspec-given/rspec-given"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "doc/main.rdoc", "--title", "RSpec Given Extensions"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "given"
  s.rubygems_version = "2.5.1"
  s.summary = "Core engine for RSpec::Given and Minitest::Given."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sorcerer>, [">= 0.3.7"])
    else
      s.add_dependency(%q<sorcerer>, [">= 0.3.7"])
    end
  else
    s.add_dependency(%q<sorcerer>, [">= 0.3.7"])
  end
end
