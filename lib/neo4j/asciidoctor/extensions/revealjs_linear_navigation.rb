# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'revealjs_linear_navigation/extension'

Asciidoctor::Extensions.register do
  tree_processor Neo4j::AsciidoctorExtensions::RevealJsLinearNavigationTreeProcessor
end
