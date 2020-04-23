# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'document_metadata_generator/extension'

Asciidoctor::Extensions.register do
  postprocessor Neo4j::AsciidoctorExtensions::DocumentMetadataGeneratorPostProcessor
end
