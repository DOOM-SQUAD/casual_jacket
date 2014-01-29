Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '2.1.10'

  s.name              = 'casual_jacket'
  s.version           = '1.1.0'
  s.date              = '2013-12-19'

  s.description   = %q{A library to cache and retrieve information from a spreadsheet}
  s.summary       = %q{A library to cache and retrieve information from a spreadsheet}

  s.authors       = ["James Christie", "Christopher Hobbs"]
  s.email         = ["jchristie@acumenholdings.com", "chobbs@acumenholdings.com"]
  s.homepage      = "https://github.com/acumenbrands/casual_jacket"

  s.require_paths = %w[lib]

  s.extra_rdoc_files = %w[README.md]

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
  ]
  # = MANIFEST =

  s.test_files = s.files.grep(%r{^spec/})
end
