# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/neo4j/asciidoctor/extensions/cypher_syntax_role'

describe Neo4j::AsciidoctorExtensions::CypherSyntaxRoleTreeProcessor do
  context 'convert to html5' do
    it 'should add role syntax on cypher-syntax source block' do
      input = <<~'ADOC'
        [source,cypher-syntax]
        ----
        ()
        (p)
        (l)
        (n)
        ----
      ADOC
      output = Asciidoctor.convert(input, standalone: false)
      (expect output).to eql %(<div class="listingblock syntax">
<div class="content">
<pre class="highlight"><code class="language-cypher-syntax" data-lang="cypher-syntax">()
(p)
(l)
(n)</code></pre>
</div>
</div>)
    end
  end
end
