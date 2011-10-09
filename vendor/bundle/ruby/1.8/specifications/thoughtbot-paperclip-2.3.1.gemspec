# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "thoughtbot-paperclip"
  s.version = "2.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Yurek"]
  s.date = "2009-08-21"
  s.email = "jyurek@thoughtbot.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://www.thoughtbot.com/projects/paperclip"
  s.rdoc_options = ["--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.requirements = ["ImageMagick"]
  s.rubyforge_project = "paperclip"
  s.rubygems_version = "1.8.11"
  s.summary = "File attachments as attributes for ActiveRecord"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
