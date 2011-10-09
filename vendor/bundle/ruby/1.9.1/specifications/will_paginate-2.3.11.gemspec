# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{will_paginate}
  s.version = "2.3.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\u00C4\u0087", "PJ Hyett"]
  s.date = %q{2009-06-02}
  s.description = %q{The will_paginate library provides a simple, yet powerful and extensible API for ActiveRecord pagination and rendering of pagination links in ActionView templates.}
  s.email = %q{mislav.marohnic@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "CHANGELOG.rdoc"]
  s.files = ["README.rdoc", "LICENSE", "CHANGELOG.rdoc"]
  s.homepage = %q{http://github.com/mislav/will_paginate/wikis}
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Most awesome pagination solution for Rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
