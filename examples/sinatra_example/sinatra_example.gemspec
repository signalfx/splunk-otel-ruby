# frozen_string_literal: true

require_relative "lib/sinatra_example/version"

Gem::Specification.new do |spec|
  spec.name          = "sinatra_example"
  spec.version       = SinatraExample::VERSION
  spec.authors       = ["Tristan Sloughter"]
  spec.email         = ["tsloughter+work@splunk.com"]

  spec.summary       = "Example instrumented sinatra app"
  spec.description   = "Example instrumented sinatra app"
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
