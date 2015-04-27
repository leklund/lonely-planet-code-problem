require 'minitest/autorun'
require 'test_helper'

class TaxonomyNodeTest < MiniTest::Test
  def setup
    @node = LonelyPlanet::TaxonomyNode.new({id: 1, name: 'test'})
  end


  def test_node_responds_to_accessors
    assert_respond_to @node, :parent
    assert_respond_to @node, :children
    assert_respond_to @node, :id
    assert_respond_to @node, :name
  end
  def test_node_responds_to_add_child
    assert_respond_to @node, :add_child
  end


  def test_node_new_requires_hash
    assert_raises (RuntimeError) { LonelyPlanet::TaxonomyNode.new('foo') }
  end

  def test_node_new_requires_name_and_id_opts
    assert_raises (RuntimeError) { LonelyPlanet::TaxonomyNode.new({}) }
    assert_raises (RuntimeError) { LonelyPlanet::TaxonomyNode.new({id:1}) }
    assert_raises (RuntimeError) { LonelyPlanet::TaxonomyNode.new({name:1}) }
  end

  def test_node_creation
    assert_equal 1, @node.id
    assert_equal 'test', @node.name
  end

  def test_node_parent
    @child = LonelyPlanet::TaxonomyNode.new({id: 2, name: 'zoot boot', parent: @node})
    assert_equal 'test', @child.parent.name
  end

  def test_children_should_be_an_array
    assert_kind_of Array, @node.children
  end

  def test_add_child_should_add_id_to_node_children
    @node.add_child(LonelyPlanet::TaxonomyNode.new({id: 2, name: 'zoot boot', parent: @node}))
    @node.add_child(LonelyPlanet::TaxonomyNode.new({id: 3, name: 'no way!', parent: @node}))
    assert_equal [2,3], @node.children
  end

end

