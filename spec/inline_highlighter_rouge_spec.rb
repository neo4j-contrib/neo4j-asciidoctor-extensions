# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/neo4j/asciidoctor/extensions/inline_highlighter_rouge'

# rubocop:disable Metrics/LineLength
describe Neo4j::AsciidoctorExtensions::InlineHighlighter::MonospacedTextInlineMacro do
  context 'convert to html5' do
    it 'should apply syntax highlighting on monospaced text cypher' do
      input = <<~'ADOC'
        [src-cypher]`MATCH (c:Customer {customerName: 'ABCCO'}) RETURN c.BOUGHT.productName`
      ADOC
      output = Asciidoctor.convert(input, doctype: 'inline')
      expect(output).to eql '<code class="rouge"><span style="color: #000000;font-weight: bold">MATCH</span><span style="color: #bbbbbb"> </span><span style="color: #990073">(</span><span style="background-color: #f8f8f8">c:</span><span style="background-color: #f8f8f8">Customer</span> <span style="color: #990073">{</span><span style="background-color: #f8f8f8">customerName:</span> <span style="color: #d14">\'ABCCO\'</span><span style="color: #990073">})</span> <span style="color: #000000;font-weight: bold">RETURN</span> <span style="background-color: #f8f8f8">c.BOUGHT.productName</span></code>'
    end
  end
end

describe Neo4j::AsciidoctorExtensions::InlineHighlighter::SrcInlineMacro do
  context 'convert to html5' do
    it 'should apply syntax highlighting on src inline macro' do
      input = <<~'ADOC'
        src:cypher[MATCH (c:Customer {customerName: 'ABCCO'}) RETURN c.BOUGHT.productName]
      ADOC
      output = Asciidoctor.convert(input, doctype: 'inline')
      expect(output).to eql '<code class="rouge"><span style="color: #000000;font-weight: bold">MATCH</span><span style="color: #bbbbbb"> </span><span style="color: #990073">(</span><span style="background-color: #f8f8f8">c:</span><span style="background-color: #f8f8f8">Customer</span> <span style="color: #990073">{</span><span style="background-color: #f8f8f8">customerName:</span> <span style="color: #d14">\'ABCCO\'</span><span style="color: #990073">})</span> <span style="color: #000000;font-weight: bold">RETURN</span> <span style="background-color: #f8f8f8">c.BOUGHT.productName</span></code>'
    end
  end
end
# rubocop:enable Metrics/LineLength
