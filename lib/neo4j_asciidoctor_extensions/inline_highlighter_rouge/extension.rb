# frozen_string_literal: true

require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

module Neo4j
  # Asciidoctor extensions by Neo4j
  module AsciidoctorExtensions
    include Asciidoctor

    # Inline syntax highlighter based on Rouge.
    #
    module InlineHighlighter
      def self.highlight_code(lang, text, doc)
        return '' if text.nil? || text.strip.empty?

        lexer = Rouge::Lexer.find lang
        theme = Rouge::Theme.find(doc.attr('rouge-style', 'github')).new
        formatter = Rouge::Formatters::HTMLInline.new(theme)
        formatter.format(lexer.lex(text))
      end

      # Apply syntax highlighting on monospaced text cypher:
      #
      # Usage:
      #
      # # [src-cypher]`MATCH (c:Customer {customerName: 'ABCCO'}) RETURN c.BOUGHT.productName`
      #
      class MonospacedTextInlineMacro < Extensions::InlineMacroProcessor
        use_dsl
        named :monospaced_highlighter
        match %r{<code class="src-([a-z]+)">([^<]+)<\/code>}i
        positional_attributes :content

        def process(parent, target, attrs)
          raw_text = attrs[:content]
          raw_text = raw_text.gsub('&#8594;', '->') if raw_text.include? '&'
          raw_text = raw_text.gsub('&#8592;', '<-') if raw_text.include? '&'
          highlighted_text = InlineHighlighter.highlight_code(target, raw_text, parent.document)
          create_inline_pass parent, %(<code class="rouge">#{highlighted_text}</code>), attrs
        end
      end

      # Apply syntax highlighting on src inline macro:
      #
      # Usage:
      #
      # # src:cypher[MATCH (c:Customer {customerName: 'ABCCO'}) RETURN c.BOUGHT.productName]
      #
      class SrcInlineMacro < Extensions::InlineMacroProcessor
        use_dsl
        named :src
        positional_attributes :content

        def process(parent, target, attrs)
          new_text = InlineHighlighter.highlight_code(target, attrs[:content], parent.document)
          create_inline_pass parent, %(<code class="rouge">#{new_text}</code>), attrs
        end
      end
    end
  end
end
