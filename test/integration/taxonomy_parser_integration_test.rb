require 'minitest/autorun'
require 'test_helper'

class TaxonomyParserIntegrationTest < MiniTest::Test
  def setup
    @doc = LonelyPlanet::TaxonomyParser.new
    @parser = Nokogiri::XML::SAX::Parser.new(@doc)
  end
  def teardown
    @doc = nil
    @parser = nil
  end

  def test_doc_tree_should_be_a_taxonomy_tree
    assert_kind_of LonelyPlanet::TaxonomyTree, @doc.tree
  end

  def test_parser_should_add_nodes_to_the_tree
    @parser.parse_file('test/fixtures/taxonomy_sample.xml')
    not_expected = {}
    refute_equal not_expected, @doc.tree.nodes
  end

  def test_parser_should_add_nodes_from_xml
    @parser.parse_file('test/fixtures/taxonomy_sample.xml')
    tree = @doc.tree
    assert_equal 'South Africa', tree.node(355611).name
    assert_equal 'Africa', tree.node(355611).parent.name
  end

  def test_acenstors
    # Africa -> South Africa -> Cape Town -> Table Mountain National Park (355613)
    @parser.parse_file('test/fixtures/taxonomy_sample.xml')
    tree = @doc.tree

    a = tree.ancestors(tree.node(355613))
    expected = 'Africa,South Africa,Cape Town'
    assert_equal expected, a.map(&:name).join(',')
  end

  def test_ampersand_handling
    @parser.parse_file('test/fixtures/taxonomy_sample.xml')
    tree = @doc.tree
    assert_equal 'Ampersand & Test', tree.node(42).name
  end

end

