# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'neo4j-asciidoctor-extensions'
  s.version = '1.0.1'
  s.summary = 'Asciidoctor extensions by Neo4j.'
  s.description = 'Asciidoctor extensions by Neo4j.'

  s.authors = ['Guillaume Grossetie']
  s.email = ['ggrossetie@yuzutech.fr']
  s.homepage = 'https://github.com/neo4j-contrib/neo4j-asciidoctor-extensions'
  s.license = 'Apache'
  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/neo4j-contrib/neo4j-asciidoctor-extensions/issues',
    'source_code_uri' => 'https://github.com/neo4j-contrib/neo4j-asciidoctor-extensions'
  }
  s.files = `git ls-files`.split($RS)
  s.require_paths = ['lib']

  s.add_runtime_dependency 'asciidoctor', '~> 2.0'
  s.add_runtime_dependency 'asciidoctor-pdf', '~> 2.3'
  s.add_runtime_dependency 'rouge', '~> 3.18'

  s.add_development_dependency 'asciidoctor-revealjs', '~> 4.0'
  s.add_development_dependency 'rake', '~> 12.3.2'
  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'rubocop', '~> 1.44.0'
end
