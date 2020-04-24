# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # A tree processor that update an attribute depending on a given rule.
    #
    class AttributeUpdateTreeProcessor < Extensions::TreeProcessor
      use_dsl

      def process(document)
        if (attribute_name = @config[:attr_name]) &&
           (current_value = document.attr attribute_name) &&
           (update_rule = @config[:update_rule])
          new_value = update_rule.call(document, current_value)
          document.set_attr attribute_name, new_value if new_value != current_value
        end
        document
      end
    end

    # A tree processor that update the "slug" attribute depending on the "stage" attribute.
    #
    class StageSlugTreeProcessor < AttributeUpdateTreeProcessor
      TESTING_SLUG_PREFIX = '_testing_'

      def initialize(config = nil)
        super
        @config[:attr_name] = 'slug'
        @config[:update_rule] = lambda { |document, value|
          case document.attr('stage')
          when 'production'
            value
          else
            "#{TESTING_SLUG_PREFIX}#{value}"
          end
        }
      end
    end
  end
end
