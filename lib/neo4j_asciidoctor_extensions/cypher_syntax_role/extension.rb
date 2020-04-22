# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # A tree processor that adds a role on code blocks using "cypher-syntax" as a language.
    #
    # Usage:
    #
    #   [source,cypher-syntax]
    #   ----
    #   ()
    #   (p)
    #   (l)
    #   (n)
    #   ----
    #
    class CypherSyntaxRoleTreeProcessor < Extensions::TreeProcessor
      use_dsl

      def process(document)
        document.find_by(context: :listing) { |block| block.attr('language') == 'cypher-syntax' }.each do |block|
          block.add_role('syntax')
        end
        document
      end
    end
  end
end
