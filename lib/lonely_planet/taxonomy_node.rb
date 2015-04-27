module LonelyPlanet
  class TaxonomyNode
    attr_accessor :id, :name, :parent, :children

    # create a new node
    # takes a jhash with the following keys
    #   id (required)     =>  integer
    #   name (required)   =>  string
    #   parent (optional) =>  TaxonomyNode
    def initialize(opts = {})
      # validate options
      raise "Options needs to be hash. Got #{opts.class}." unless opts.is_a?(Hash)
      raise "Missing required option :id" if opts[:id].nil?
      raise "Missing required option :name" if opts[:name].nil?

      # create with the options
      @id = opts[:id]
      @name = opts[:name]
      @parent = opts[:parent]

      # add children if passed an array or initialize as an empty array
      @children = opts[:children].is_a?(Array) ? opts[:children] : []
    end

    # add children as aray of ids rather than a set of TaxonomyNode objects
    def add_child(node)
      @children << node.id
    end
  end
end
