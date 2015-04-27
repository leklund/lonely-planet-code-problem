require 'minitest/autorun'
require 'test_helper'

class TaxonomyTreeTest < MiniTest::Test
  def setup
    @tree = LonelyPlanet::TaxonomyTree.new
    @node = LonelyPlanet::TaxonomyNode.new({id: 1, name: 'test'})
  end

  def test_tree_should_respond_to_nodes
    assert_respond_to @tree, :nodes
  end

  def test_tree_nodes_should_be_hash
    assert_kind_of Hash, @tree.nodes
  end

  def test_tree_should_respond_to_node
    assert_respond_to @tree, :node
  end

  def test_tree_should_accept_id_like_a_hash_and_return_corresponding_node
    @tree.add_node(@node)
    node = @tree[1]
    assert_equal node, @node
  end

  def test_tree_node_should_take_id_and_return_corresponding_node
    @tree.add_node(@node)
    node = @tree.node(1)
    assert_equal node, @node
  end

  def test_tree_should_respond_to_add_node
    assert_respond_to @tree, :add_node
  end

  def test_tree_add_node_should_raise_error_if_not_passed_node
    assert_raises (RuntimeError) { @tree.add_node(1) }
  end

  def test_add_node_should_add_a_node
    assert @tree.add_node(@node)
    expected = {1 => @node}
    assert_equal expected, @tree.nodes
  end

  def test_when_node_is_added_with_parent_a_child_should_be_added_to_said_parent
    @tree.add_node(@node)
    node2 = LonelyPlanet::TaxonomyNode.new({id: 2, name: 'node 2', parent: @node})
    node3 = LonelyPlanet::TaxonomyNode.new({id: 3, name: 'node 3', parent: @node})
    @tree.add_node(node2)
    @tree.add_node(node3)

    assert_equal [2,3], @tree.node(1).children
  end

  def test_when_node_is_added_with_parent_and_parent_is_not_part_of_tree_should_raise_error
    node2 = LonelyPlanet::TaxonomyNode.new({id: 2, name: 'node 2', parent: @node})
    assert_raises (RuntimeError) {@tree.add_node(node2)}
  end

  def test_tree_should_respond_to_ancestors
    assert_respond_to @tree, :ancestors
  end

  def test_ancestors_should_raise_error_if_not_passed_node
    assert_raises (RuntimeError) { @tree.ancestors(42) }
  end

  def test_node_without_ancestors_should_return_nil
    @tree.add_node(@node)
    ancestors = @tree.ancestors(@node)
    assert_nil ancestors
  end

  def test_ancestors_should_return_array_of_nodes
    @tree.add_node(@node)
    node2 = LonelyPlanet::TaxonomyNode.new({id: 2, name: 'node 2', parent: @node})
    node3 = LonelyPlanet::TaxonomyNode.new({id: 3, name: 'node 3', parent: node2})
    node4 = LonelyPlanet::TaxonomyNode.new({id: 4, name: 'node 4', parent: node3})
    @tree.add_node(node2)
    @tree.add_node(node3)
    @tree.add_node(node4)
    ancestors = @tree.ancestors(node4)

    assert_kind_of Array, ancestors
    assert !ancestors.empty? && ancestors.all?{|a| a.is_a?(LonelyPlanet::TaxonomyNode)}
  end

  def test_tree_should_respond_to_path
    assert_respond_to @tree, :path
  end

  def test_tree_should_raise_error_if_not_passed_node
    assert_raises (RuntimeError) { @tree.path(1) }
  end

  def test_path_return_a_string
    @tree.add_node(@node)
    path = @tree.path(@node)
    assert_kind_of String, path
  end

  def test_path_without_ancestors_should_be_downcased_underscored_name_and_extension
    node2 = LonelyPlanet::TaxonomyNode.new({id: 2, name: 'new-node 2'})
    @tree.add_node(node2)
    path = @tree.path(node2)
    assert_equal '/new-node_2.html', path

  end
  def test_path_should_be_slash_separated_ancestors
    @tree.add_node(@node)
    node2 = LonelyPlanet::TaxonomyNode.new({id: 2, name: 'node 2', parent: @node})
    node3 = LonelyPlanet::TaxonomyNode.new({id: 3, name: 'node 3', parent: node2})
    node4 = LonelyPlanet::TaxonomyNode.new({id: 4, name: 'node 4', parent: node3})
    @tree.add_node(node2)
    @tree.add_node(node3)
    @tree.add_node(node4)

    path = @tree.path(node4)

    assert_equal '/test/node_2/node_3/node_4.html', path
  end

end
