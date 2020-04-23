# frozen_string_literal: true

require 'asciidoctor'
require 'asciidoctor-revealjs'
require_relative '../lib/neo4j/asciidoctor/extensions/revealjs_linear_navigation'

describe Neo4j::AsciidoctorExtensions::RevealJsLinearNavigationTreeProcessor do
  context 'convert to reveal.js' do
    it 'should produce a linear navigation' do
      input = <<~'ADOC'
        = Introduction to Neo4j 4.0

        == a

        === b

        ==== c

        === d

        == e

        === f

        == g

        == h

        === i

        ==== j

        ==== k

        == l
      ADOC
      output = Asciidoctor.convert(input, backend: 'revealjs')
      expect(output).to eql %(<section id="_a"><h2>a</h2></section>
<section id="_b"><h2>b</h2></section>
<section id="_c"><h2>c</h2></section>
<section id="_d"><h2>d</h2></section>
<section id="_e"><h2>e</h2></section>
<section id="_f"><h2>f</h2></section>
<section id="_g"><h2>g</h2></section>
<section id="_h"><h2>h</h2></section>
<section id="_i"><h2>i</h2></section>
<section id="_j"><h2>j</h2></section>
<section id="_k"><h2>k</h2></section>
<section id="_l"><h2>l</h2></section>)
    end
  end
end
