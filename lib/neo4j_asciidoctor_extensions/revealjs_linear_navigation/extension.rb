# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # A tree process that "flatten" a reveal.js presentation to use a linear navigation.
    # By default, the reveal.js converter will use a vertical navigation for the second levels of section titles (and below).
    # This extension will effectively prevent that by using only first level section titles.
    #
    class RevealJsLinearNavigationTreeProcessor < Extensions::TreeProcessor
      use_dsl

      def process(document)
        if document.backend == 'revealjs'
          document.find_by(context: :section) { |section| section.level > 1 }.reverse_each do |section|
            section.parent.blocks.delete(section)
            parent_section = section.parent
            parent_section = parent_section.parent while parent_section.parent && parent_section.parent.context == :section
            section.level = 1
            document.blocks.insert(parent_section.index + 1, section)
          end
        end
        document
      end
    end
  end
end
