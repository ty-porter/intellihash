# frozen_string_literal: true

require_relative 'lib/smart_hash/version'

Gem::Specification.new do |spec|
  spec.name          = 'smart_hash'
  spec.version       = SmartHash::VERSION
  spec.authors       = ['Tyler Porter']
  spec.email         = ['tyler.b.porter@gmail.com']

  spec.summary       = 'A fast implementation of hashes as objects'
  spec.description   = <<~DESC
        A fast implementation of hashes as objects, benchmarked against OpenStruct.
    #{'    '}
        It allows chaining hash attributes as method calls instead of standard hash syntax.
  DESC
  spec.homepage      = 'https://github.com/ty-porter/smart_hash'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.5')
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ty-porter/smart_hash'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency('byebug', ['>= 0'])
  spec.add_development_dependency('rspec-benchmark', ['~> 0.5.0'])
  spec.add_development_dependency('rubocop', ['~> 1.18'])
end
