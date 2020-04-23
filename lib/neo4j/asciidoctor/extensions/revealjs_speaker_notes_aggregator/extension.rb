# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # A tree processor that aggregates multiple [notes] blocks in a section (slide).
    #
    # Usage:
    #
    #   == Introduction
    #
    #   [.notes]
    #   --
    #   This is a speaker note.
    #   --
    #
    #   Hello!
    #
    #   [.notes]
    #   --
    #   This is another speaker note.
    #   --
    #
    class RevealJsSpeakerNotesAggregatorTreeProcessor < Extensions::TreeProcessor
      use_dsl

      def process(document)
        if document.backend == 'revealjs'
          document.find_by(context: :section).each do |section|
            notes_blocks = section.blocks.select { |block| block.context == :open && block.roles.include?('notes') }
            next if notes_blocks.empty?

            agg_notes_block = Asciidoctor::Block.new(section, :open, attributes: { 'role' => 'notes' })
            notes_blocks.each do |notes_block|
              section.blocks.delete(notes_block)
              notes_block.remove_role('notes')
              agg_notes_block << notes_block
            end
            section.blocks << agg_notes_block
          end
        end
        document
      end
    end
  end
end
