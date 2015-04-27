require 'minitest/autorun'
require 'test_helper'

class DestinationParserIntegrationTest < MiniTest::Test
  def setup
    Dir.mkdir('test/tmpout') unless Dir.exist?('test/tmpout')
    doc = LonelyPlanet::TaxonomyParser.new
    tax_parser = Nokogiri::XML::SAX::Parser.new(doc)
    tax_parser.parse_file('test/fixtures/taxonomy_sample.xml')
    @parser = LonelyPlanet::DestinationParser.new(doc.tree, 'test/tmpout')
  end

  def test_parser_should_create_files
    @parser.parse('test/fixtures/destinations.xml')

    assert File.exist?('test/tmpout/africa.html'), 'Files should be created in the tmpout directory'
  end

  def teardown
    FileUtils.remove_dir('test/tmpout', true) if Dir.exist?('test/tmpout')
  end
end

