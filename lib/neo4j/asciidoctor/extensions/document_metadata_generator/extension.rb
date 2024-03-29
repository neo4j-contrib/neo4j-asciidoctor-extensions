# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # Type of value
    module ValueType
      # string
      STRING = 1
      # [string]
      LIST_STRING = 2
      # [<string,string>]
      LIST_TUPLES = 3
    end

    # A postprocess that generates a metadata file (in YAML format) from a list of document attributes.
    #
    # Usage:
    #
    #   # .file.adoc
    #   #:document-metadata-attrs-include: author,slug,parent-path,tags*,taxonomies*<>
    #   #:tags: intro,course
    #   #:taxonomies: os=linux,programming_language=java,neo4j_version=3-5;3-6
    #   #:slug: intro-neo4j-4-0
    #   #:parent_path: /intro
    #
    #   # .file.yml
    #   # ---
    #   # slug: intro-neo4j-4-0
    #   # parent_path: /intro
    #   # author:
    #   #   name: Michael Hunger
    #   #   first_name: Michael
    #   #   last_name: Hunger
    #   #   email: michael.hunger@neotechnology.com
    #   # tags:
    #   #   - intro
    #   #   - course
    #   # taxonomies:
    #   #   - key: os
    #   #     values:
    #   #       - linux
    #   #   - key: programming_language
    #   #     values:
    #   #       - java
    #   #   - key: neo4j_version
    #   #     values:
    #   #       - 3-5
    #   #       - 3-6
    class DocumentMetadataGeneratorPostProcessor < Extensions::Postprocessor
      use_dsl

      def process(document, output)
        if (attrs_include = document.attr 'document-metadata-attrs-include') && (outfile = document.attr 'outfile')
          require 'yaml'
          metadata = {}
          attrs_include = attrs_include
                          .split(',')
                          .map(&:strip)
                          .reject(&:empty?)

          attrs_include.each do |attr_include|
            value_type = resolve_value_type(attr_include)
            attr_name = resolve_attr_name(attr_include)
            if document.attr? attr_name
              attr_value = resolve_attribute_value(attr_name, document, value_type)
              metadata[attr_name.gsub('-', '_')] = attr_value
            end
          end
          metadata['title'] = document.doctitle
          write(metadata, outfile)
        end
        output
      end

      private

      def resolve_value_type(attr_include)
        if attr_include.end_with? '*'
          ValueType::LIST_STRING
        elsif (attr_include.end_with? '*&lt;&gt;') || (attr_include.end_with? '*<>')
          ValueType::LIST_TUPLES
        else
          ValueType::STRING
        end
      end

      def resolve_attr_name(attr_include)
        attr_include
          .gsub(/\*$/, '')
          .gsub(/\*&lt;&gt;$/, '')
          .gsub(/\*<>$/, '')
      end

      def write(metadata, outfile)
        outputdir = File.dirname(outfile)
        filename = File.basename(outfile, File.extname(outfile))
        File.write("#{outputdir}/#{filename}.yml", metadata.to_yaml)
      end

      def resolve_attribute_value(attr_name, document, value_type)
        if attr_name == 'author'
          author = {}
          author['name'] = document.attr 'author'
          author['first_name'] = document.attr 'firstname'
          author['last_name'] = document.attr 'lastname'
          author['email'] = document.attr 'email'
          author
        elsif value_type == ValueType::LIST_STRING
          split_values(attr_name, document)
        elsif value_type == ValueType::LIST_TUPLES
          split_values(attr_name, document)
            .map do |tuple|
            key, value = tuple.split('=')
            { 'key' => key.strip, 'values' => (value && value.strip.split(';').map(&:strip).reject(&:empty?)) || [] }
          end
        else
          document.attr attr_name
        end
      end

      def split_values(attr_name, document)
        (document.attr attr_name)
          .split(',')
          .map(&:strip)
          .reject(&:empty?)
      end
    end
  end
end
