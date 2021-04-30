# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative "lib/dxruby_editor/version"

Gem::Specification.new do |spec|
  spec.name          = "dxruby_editor"
  spec.version       = DxrubyEditor::VERSION
  spec.authors       = ["stonesaw"]
  spec.email         = ["mail.sou.dev@gmail.com"]

  spec.summary       = "Editor extension for DXRuby, a 2D game library"
  spec.description   = "An editor (similar to vscode) and runtime environment for DXRuby."
  spec.homepage      = "https://github.com/stonesaw/dxruby_editor"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "dxruby"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rubocop-airbnb"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
