# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/neo4j/asciidoctor/extensions/document_metadata_generator'

RSpec.configure do |config|
  config.after(:each) do
    FileUtils.rm_rf('spec/output') unless ENV['DEBUG']
  end

  config.before(:each) do
    FileUtils.mkdir_p('spec/output')
  end
end

describe Neo4j::AsciidoctorExtensions::DocumentMetadataGeneratorPostProcessor do
  context 'convert to html5' do
    it 'should generate default metadata' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :document-metadata-attrs-include:

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html')
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
    end
    it 'should generate metadata with slug (string)' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :document-metadata-attrs-include: slug
        :slug: introduction-neo4j-4-0

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html')
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
    end
    it 'should generate metadata with tags (list of strings)' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :document-metadata-attrs-include: slug,tags*
        :slug: introduction-neo4j-4-0
        :tags:  intro , neo4j,,

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html')
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
      expect(metadata['tags']).to eql(%w[intro neo4j])
    end
    it 'should generate metadata with taxonomies (list of tuples) using document attribute' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :document-metadata-attrs-include: slug,tags*,taxonomies*<>
        :slug: introduction-neo4j-4-0
        :tags:  intro , neo4j,,
        :taxonomies:  os= linux,,programming_language =java, neo4j_version=3-5; 3-6;

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html')
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
      expect(metadata['tags']).to eql(%w[intro neo4j])
      taxonomies = metadata['taxonomies']
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'os' }['values']).to eql(%w[linux])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'programming_language' }['values']).to eql(%w[java])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'neo4j_version' }['values']).to eql(%w[3-5 3-6])
    end
    it 'should generate metadata with taxonomies (list of tuples) using document attribute with pass' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :document-metadata-attrs-include: pass:[slug,tags*,taxonomies*<>]
        :slug: introduction-neo4j-4-0
        :tags:  intro , neo4j,,
        :taxonomies:  os= linux,,programming_language =java, neo4j_version=3-5; 3-6;

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html')
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
      expect(metadata['tags']).to eql(%w[intro neo4j])
      taxonomies = metadata['taxonomies']
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'os' }['values']).to eql(%w[linux])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'programming_language' }['values']).to eql(%w[java])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'neo4j_version' }['values']).to eql(%w[3-5 3-6])
    end
    it 'should generate metadata with taxonomies (list of tuples) using CLI attribute' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :slug: introduction-neo4j-4-0
        :tags:  intro , neo4j,,
        :taxonomies:  os= linux,,programming_language =java, neo4j_version=3-5; 3-6;

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html', attributes: {
                            'document-metadata-attrs-include' => 'slug,tags*,taxonomies*<>'
                          })
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
      expect(metadata['tags']).to eql(%w[intro neo4j])
      taxonomies = metadata['taxonomies']
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'os' }['values']).to eql(%w[linux])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'programming_language' }['values']).to eql(%w[java])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'neo4j_version' }['values']).to eql(%w[3-5 3-6])
    end
    it 'should replace - by _ in the attribute name' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :slug: introduction-neo4j-4-0
        :parent-path: /labs

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html', attributes: {
                            'document-metadata-attrs-include' => 'slug,parent-path'
                          })
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
      expect(metadata['parent_path']).to eql('/labs')
    end
    it 'should ignore empty value in taxonomies' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0
        :slug: introduction-neo4j-4-0
        :taxonomies: neo4j_versions= , tags= intro ; neo4j;;

        This is a paragraph.
      ADOC
      Asciidoctor.convert(input, safe: 'safe', to_file: 'spec/output/test.html', attributes: {
          'document-metadata-attrs-include' => 'slug,taxonomies*<>'
      })
      metadata = YAML.load_file('spec/output/test.yml')
      expect(metadata['title']).to eql('Introduction to Neo4j 4.0')
      expect(metadata['slug']).to eql('introduction-neo4j-4-0')
      taxonomies = metadata['taxonomies']
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'neo4j_versions' }['values']).to eql([])
      expect(taxonomies.detect { |taxonomy| taxonomy['key'] == 'tags' }['values']).to eql(%w[intro neo4j])
    end
  end
end
