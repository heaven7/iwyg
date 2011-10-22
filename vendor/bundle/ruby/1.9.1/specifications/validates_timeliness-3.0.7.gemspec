# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{validates_timeliness}
  s.version = "3.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Meehan"]
  s.date = %q{2011-09-20}
  s.description = %q{Adds validation methods to ActiveModel for validating dates and times. Works with multiple ORMS.}
  s.email = %q{adam.meehan@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "CHANGELOG.rdoc", "LICENSE"]
  s.homepage = %q{http://github.com/adzap/validates_timeliness}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Date and time validation plugin for Rails which allows custom formats}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<timeliness>, ["~> 0.3.3"])
    else
      s.add_dependency(%q<timeliness>, ["~> 0.3.3"])
    end
  else
    s.add_dependency(%q<timeliness>, ["~> 0.3.3"])
  end
end