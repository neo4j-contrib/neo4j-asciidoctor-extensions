# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'cypher_syntax_role/extension'

Asciidoctor::Extensions.register do
  tree_processor Neo4j::AsciidoctorExtensions::CypherSyntaxRoleTreeProcessor
end
