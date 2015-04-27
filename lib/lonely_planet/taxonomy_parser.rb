module LonelyPlanet
  # Lonely Planet XML Taxonomy parser
  class TaxonomyParser < Nokogiri::XML::SAX::Document
    # because we are using SAX we need to keep track of where we are in the document
    # and also the current parent so that we can generate a tree.
    attr_accessor :depth, :parents, :current, :current_name, :tree, :context

    def initialize
      @depth = 0
      @parents = []
      @tree = LonelyPlanet::TaxonomyTree.new
      @current_name = ''
    end

    # the start_element is called during document parsing
    # at the beginning of each new XML element.
    def start_element(name, attributes= [])
      if name == 'node'
        @context = name
        hattr = Hash[attributes]
        curr = hattr['atlas_node_id'] || hattr['geo_id']
        raise 'Can not parse a node without an atlas_node_id or geo_id' if curr.nil?
        @current = curr.to_i
        @parents.push @current
        @depth +=1
      elsif name == 'node_name'
        @context = name
      end
    end

    # get the text between elements
    # accumulate to @current_name while in node_name context. The accumulator is used so that
    # the parser can handle text with ampersands.
    def characters(txt)
      if @context == 'node_name' && !@current.nil?
        @current_name << txt
      end
    end

    # called at the end of each element
    # * resets context and decreases depth if we closed a node element
    # * creates node and adds to tree when node_name is closed
    # * resets current_name is node_name is closed
    def end_element(name)
      @context = nil
      if name == 'node'
        @depth -= 1
        @parents.pop
      elsif name == 'node_name'
        # root nodes don't need parents
        p = (parent.nil? || @depth == 0) ? nil : @tree.node(parent)
        node = LonelyPlanet::TaxonomyNode.new({id: @current, name: @current_name, parent: p})
        @tree.add_node(node)
        @current_name = ''
      end
    end


    # helper method to get the current parent from the array
    def parent
      @parents[-2]
    end
  end
end
