# frozen_string_literal: true

require 'asciidoctor'
require 'asciidoctor/extensions'
require_relative '../lib/neo4j/asciidoctor/extensions/attribute_update/extension'

describe Neo4j::AsciidoctorExtensions::StageSlugTreeProcessor do
  context 'convert to html5' do
    it 'should update slug' do
      registry = Asciidoctor::Extensions.create
      registry.tree_processor Neo4j::AsciidoctorExtensions::StageSlugTreeProcessor
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :slug: intro-neo4j-4-0

        {slug}
      ADOC
      output = Asciidoctor.convert(input, extension_registry: registry, standalone: false, doctype: 'inline')
      (expect output).to eql '_testing_intro-neo4j-4-0'
    end
    it 'should not update slug' do
      registry = Asciidoctor::Extensions.create
      registry.tree_processor Neo4j::AsciidoctorExtensions::StageSlugTreeProcessor
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :stage: production
        :slug: intro-neo4j-4-0

        {slug}
      ADOC
      output = Asciidoctor.convert(input, extension_registry: registry, standalone: false, doctype: 'inline')
      (expect output).to eql 'intro-neo4j-4-0'
    end
  end
end
