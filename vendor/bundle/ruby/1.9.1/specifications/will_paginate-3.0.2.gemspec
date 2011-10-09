# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{will_paginate}
  s.version = "3.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\u00C4\u0087"]
  s.date = %q{2011-09-27}
  s.description = %q{will_paginate provides a simple API for performing paginated queries with Active Record, DataMapper and Sequel, and includes helpers for rendering pagination links in Rails, Sinatra and Merb web apps.}
  s.email = %q{mislav.marohnic@gmail.com}
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["README.md", "LICENSE"]
  s.homepage = %q{https://github.com/mislav/will_paginate/wiki}
  s.rdoc_options = ["--main", "README.md", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Pagination plugin for web frameworks and other apps}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
