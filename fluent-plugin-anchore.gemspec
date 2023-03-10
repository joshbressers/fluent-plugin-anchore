lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-anchore"
  spec.version = "0.1.2"
  spec.authors = ["Josh Bressers"]
  spec.email   = ["josh@bress.net"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "http://example.com"
  spec.license       = "Apache 2.0"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2.3"
  spec.add_development_dependency "rake", "~> 13.0.3"
  spec.add_development_dependency "test-unit", "~> 3.3.7"
  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
end
