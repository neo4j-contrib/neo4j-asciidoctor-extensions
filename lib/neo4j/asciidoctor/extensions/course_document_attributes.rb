# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'course_document_attributes/extension'

Asciidoctor::Extensions.register do
  tree_processor Neo4j::AsciidoctorExtensions::CourseDocumentAttributesTreeProcessor
end
