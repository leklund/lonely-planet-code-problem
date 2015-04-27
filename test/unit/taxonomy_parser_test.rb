require 'minitest/autorun'
require 'test_helper'

class TaxonomyParserTest < MiniTest::Test
  def setup
    @parser = LonelyPlanet::TaxonomyParser.new
  end

  def test_parser_is_nokogiri_xml_sax_document_instance
    assert_equal Nokogiri::XML::SAX::Document, @parser.class.superclass
  end
  def test_responds_to_start_element
    assert_respond_to @parser, :start_element
  end
  def test_responds_to_end_element
    assert_respond_to @parser, :end_element
  end

  def test_responds_to_depth
    assert_respond_to @parser, :depth
  end
  def test_responds_to_context
    assert_respond_to @parser, :context
  end
  def test_depth_starts_at_0
    assert_equal 0, @parser.depth
  end
  def test_responds_to_parent
    assert_respond_to @parser, :parent
  end
  def test_responds_to_parents
    assert_respond_to @parser, :parents
  end
  def test_parentsis_an_array
    assert_kind_of Array, @parser.parents
  end
  def test_responds_to_current_name
    assert_respond_to @parser, :current_name
  end
  def test_responds_to_current
    assert_respond_to @parser, :current
  end
  def test_responds_to_tree
    assert_respond_to @parser, :tree
  end
  def test_tree_is_lonely_planet_tree
    assert_kind_of LonelyPlanet::TaxonomyTree, @parser.tree
  end

  def test_a_new_node_should_increment_depth
    @parser.start_element('node', [['atlas_node_id','1']])
    assert_equal 1, @parser.depth
  end

  def test_end_node_should_decrement_depth
    @parser.depth = 1
    @parser.end_element('node')
    assert_equal 0, @parser.depth
  end

  def test_nodes_should_set_current_id_from_atlas_node_or_geo
    @parser.start_element('node', [['atlas_node_id','123']])
    assert_equal 123, @parser.current

    @parser.start_element('node', [['geo_id','123']])
    assert_equal 123, @parser.current
  end
  def test_nodes_should_raise_error_if_id_not_found
    assert_raises (RuntimeError) {@parser.start_element('node')}
  end
  def test_parent_should_be_set_when_nodes_are_added
    @parser.start_element('node', [['atlas_node_id','1']])
    @parser.start_element('node', [['atlas_node_id','2']])
    assert_equal 1, @parser.parent
    @parser.start_element('node', [['atlas_node_id','3']])
    assert_equal 2, @parser.parent
  end

  def test_node_added_after_node_and_node_name_tags
    @parser.start_element('node', [['atlas_node_id','1']])
    @parser.start_element('node_name')
    @parser.characters('Earth')
    @parser.end_element('node_name')
    tree = @parser.tree

    assert_equal 'Earth', tree.node(1).name
  end

  

end
