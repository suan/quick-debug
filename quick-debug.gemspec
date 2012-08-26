# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "quick-debug/version"

Gem::Specification.new do |s|
  s.name        = "quick-debug"
  s.version     = D::VERSION
  s.authors     = ["Suan-Aik Yeo"]
  s.email       = ["yeosuanaik@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Quick print-based Ruby debugging}
  s.description = %q{Debug your Ruby code with just a few keystrokes!}

  s.rubyforge_project = "quick-debug"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
