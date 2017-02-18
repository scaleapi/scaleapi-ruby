# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "scaleapi"
  spec.version       = "0.1.0"
  spec.authors       = ["Alexandr Wang"]
  spec.email         = ["alex@scaleapi.com"]

  spec.summary       = %q{Official Ruby Client for Scale API}
  spec.description   = %q{Scale is an API For Human Intelligence. Get high quality results for all sorts of tasks within minutes. This is the official Ruby client.}
  spec.homepage      = "https://www.scaleapi.com"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "faraday", "0.11.0"
end
