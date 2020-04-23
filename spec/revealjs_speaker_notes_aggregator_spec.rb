# frozen_string_literal: true

require 'asciidoctor'
require 'asciidoctor-revealjs'
require_relative '../lib/neo4j_asciidoctor_extensions/revealjs_speaker_notes_aggregator'

describe Neo4j::AsciidoctorExtensions::RevealJsSpeakerNotesAggregatorTreeProcessor do
  context 'convert to reveal.js' do
    it 'should aggregate speaker notes' do
      input = <<~'ADOC'
        = Presentation

        == Introduction

        [.notes]
        --
        This is a speaker note.
        --

        Hello!

        [.notes]
        --
        This is another speaker note.
        --
      ADOC
      output = Asciidoctor.convert(input, backend: 'revealjs')
      expect(output).to eql %(<section id="_introduction"><h2>Introduction</h2><div class="slide-content"><div class="paragraph"><p>Hello!</p></div>
<aside class="notes"><div class="openblock"><div class="content"><div class="paragraph"><p>This is a speaker note.</p></div></div></div>
<div class="openblock"><div class="content"><div class="paragraph"><p>This is another speaker note.</p></div></div></div></aside></div></section>)
    end
  end
end
