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
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.3")

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


  platform = ENV["GEM_PLATFORM"] || Gem::Platform.local.to_s
  is_windows = /windows|mingw|cygwin/i.match(platform)

  if is_windows
    spec.add_runtime_dependency "dxruby", "~> 1.4.0"
    spec.platform = "x86-mingw32"
  else
    spec.add_runtime_dependency "dxruby_sdl", "~> 0.0.17"
  end

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rubocop-airbnb"
end
