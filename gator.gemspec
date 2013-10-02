# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gator"
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Shelburne"]
  s.date = "2013-10-02"
  s.description = ""
  s.email = "shelburt02@gmail.com"
  s.executables = ["gator.min.js", "gator.min.js.gz"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README.rdoc", "bin/gator.min.js", "bin/gator.min.js.gz", "lib/gator.rb", "lib/gator/symbols.rb"]
  s.files = ["CHANGELOG", "Gemfile", "Gemfile.lock", "LICENSE", "Manifest", "README.rdoc", "Rakefile", "assets/scripts/coffee/gator/navigation_graph.coffee", "assets/scripts/coffee/gator/navigation_node.coffee", "assets/scripts/coffee/gator/navigator.coffee", "bin/gator.min.js", "bin/gator.min.js.gz", "config/assets.rb", "gator.gemspec", "lib/gator.rb", "lib/gator/symbols.rb", "spec/bin/gator.js", "spec/config/assets.rb", "spec/jasmine.yml", "spec/runner.html", "spec/support/classes.coffee", "spec/support/helpers.coffee", "spec/support/mocks.coffee", "spec/support/objects.coffee", "spec/support/requirements.coffee", "spec/tests/navigation_graph_spec.coffee", "spec/tests/navigation_node_spec.coffee", "spec/tests/navigator_spec.coffee"]
  s.homepage = "https://github.com/tshelburne/gator-js"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Gator", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "gator"
  s.rubygems_version = "1.8.24"
  s.summary = ""
  s.license = "MIT"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<jasmine>, [">= 0"])
      s.add_development_dependency(%q<jasmine-headless-webkit>, [">= 0"])
    else
      s.add_dependency(%q<jasmine>, [">= 0"])
      s.add_dependency(%q<jasmine-headless-webkit>, [">= 0"])
    end
  else
    s.add_dependency(%q<jasmine>, [">= 0"])
    s.add_dependency(%q<jasmine-headless-webkit>, [">= 0"])
  end
end
