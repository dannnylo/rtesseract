# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtesseract/version'

Gem::Specification.new do |spec|
  spec.name          = 'rtesseract'
  spec.version       = RTesseract::VERSION
  spec.authors       = ['Danilo Jeremias da Silva']
  spec.email         = ['dannnylo@gmail.com']

  spec.summary       = 'Ruby library for working with the Tesseract OCR.'
  spec.description   = 'Ruby library for working with the Tesseract OCR.'
  spec.homepage      = 'http://github.com/dannnylo/rtesseract'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
