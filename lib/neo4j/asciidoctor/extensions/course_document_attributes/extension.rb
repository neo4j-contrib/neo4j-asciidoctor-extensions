# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # A postprocessor that adds attributes about the course.
    # /!\ This extension is tightly coupled to the course publishing project and should not be used for other purposes /!\
    #
    class CourseDocumentAttributesPostProcessor < Extensions::Postprocessor
      use_dsl

      # TODO: this slug should be configurable
      TESTING_SLUG_PREFIX = '_testing_'

      def process(document)
        if (docdir = document.attr 'docdir')
          # TODO: this path should be configurable
          path = File.expand_path('../build/online/asciidoctor-module-descriptor.yml', docdir)
          if File.exist?(path)
            require 'yaml'
            module_descriptor = YAML.load_file(path)
            if (document_slug = document.attr 'slug') && document.attr('stage') != 'production'
              document_slug = "#{TESTING_SLUG_PREFIX}#{document_slug}"
              document.set_attr 'slug', document_slug
            end
            set_attributes(document, document_slug, module_descriptor)
            document.set_attribute 'module-name', module_descriptor['module_name']
          end
        end
        document
      end

      private

      def set_attributes(document, document_slug, module_descriptor)
        module_descriptor['pages'].each_with_index do |page, index|
          document.set_attribute "module-toc-link-#{index}", page['url']
          document.set_attribute "module-toc-title-#{index}", page['title']
          page_slug = page['slug']
          page_slug = "#{TESTING_SLUG_PREFIX}#{page_slug}" unless document.attr('stage') == 'production'
          document.set_attribute "module-toc-slug-#{index}", page_slug
          document.set_attribute "module-quiz-#{index}", page['quiz']
          next unless document_slug == page_slug

          set_next_attributes(document, page)
          document.set_attribute 'module-quiz', page['quiz']
          document.set_attribute 'module-certificate', page['certificate']
        end
      end

      def set_next_attributes(document, page)
        return unless page.key?('next')

        next_page_slug = page['next']['slug']
        next_page_slug = "#{TESTING_SLUG_PREFIX}#{next_page_slug}" unless document.attr('stage') == 'production'
        document.set_attr 'module-next-slug', next_page_slug, false
        document.set_attr 'module-next-title', page['next']['title'], false
      end
    end
  end
end
