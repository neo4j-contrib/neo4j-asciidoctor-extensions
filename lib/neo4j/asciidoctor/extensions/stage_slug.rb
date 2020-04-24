# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'attribute_update/extension'

Asciidoctor::Extensions.register do
  tree_processor Neo4j::AsciidoctorExtensions::StageSlugTreeProcessor
end
