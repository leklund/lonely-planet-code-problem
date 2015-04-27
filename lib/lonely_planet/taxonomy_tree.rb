module LonelyPlanet
  class TaxonomyTree
    attr_accessor :nodes

    def initialize
      @nodes = {}
    end

    # add node to the tree.
    # node parameter should be a LonelyPlanet::TaxonomyNode object
    #
    # Will fail if trying to add a node with a parent that does not already exists on the tree.
    # If the parent exists it will set the parent to the existing object and add the new node
    # to the existing parent's children.
    def add_node(node)
      if node.class != LonelyPlanet::TaxonomyNode
        raise "node parameter needs to be a LonelyPlanet::TaxonomyNode. got #{node.class}"
      end
      if !node.parent.nil?
        existing_parent = self.node(node.parent.id)
        if existing_parent.nil?
          raise "Unable to add node #{node.name} to the tree. It specifies a parent #{node.parent.name} That has not been added to the tree"
        end
        node.parent = existing_parent
        existing_parent.children.push(node.id).uniq
      end
      @nodes[node.id] = node
    end

    # return the node specified by the given id
    def node(id)
      @nodes[id]
    end

    # hash like accessor for a tree object
    def [](id)
      node(id)
    end

    # return a list of ancestor nodes in order of depth
    #
    # traverses up the tree recusrively.
    def ancestors(node, ancestor_list = [])
      if node.class != LonelyPlanet::TaxonomyNode
        raise "node parameter needs to be a LonelyPlanet::TaxonomyNode. got #{node.class}"
      end
      # traverse up the tree to get all parents
      # return the list if the parent of the current node is already in the list
      if node.parent && !ancestor_list.include?(node.parent)
        ancestor_list.push node.parent
        self.ancestors(node.parent, ancestor_list)
      else
        ancestor_list.empty? ? nil : ancestor_list.reverse
      end
    end

    # generate path names for urls and for creating files an directories
    def path(node)
      if node.class != LonelyPlanet::TaxonomyNode
        raise "node parameter needs to be a LonelyPlanet::TaxonomyNode. got #{node.class}"
      end
      if node.parent.nil?
        path = path_url_name(node.name)
      else
        path = ancestors(node).push(node).map{|n| path_url_name(n.name)}.join '/'
      end
      ROOT_PATH + path + '.html'
    end

    protected
    # create url friendly path names
    def path_url_name(name)
      url_name = name.downcase
      url_name.gsub(/[^a-z0-9-]/,'_')
    end
  end
end
