# frozen_string_literal: true

require_relative 'lib/oban/version'

Gem::Specification.new do |spec|
  spec.name          = 'oban'
  spec.version       = Oban::VERSION
  spec.authors       = ['Alexandre de Souza']
  spec.email         = ['alexandre@aledsz.com.br']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/aledsz/rOban'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/aledsz/rOban/tree/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 6.0'
  spec.add_dependency 'concurrent-ruby', '~> 1.1'
  spec.add_dependency 'pg', '~> 1.2'

  spec.add_development_dependency 'rubocop-rake', '~> 0.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.3'
  spec.add_development_dependency 'standalone_migrations', '~> 6.0'
end
