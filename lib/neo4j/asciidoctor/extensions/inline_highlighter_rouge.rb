# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'
require_relative 'inline_highlighter_rouge/extension'

Asciidoctor::Extensions.register do
  inline_macro Neo4j::AsciidoctorExtensions::InlineHighlighter::MonospacedTextInlineMacro
  inline_macro Neo4j::AsciidoctorExtensions::InlineHighlighter::SrcInlineMacro
end
