module LonelyPlanet
  # Lonely Planet XML Destination parser
  class DestinationParser
    attr_accessor :tree, :template, :output_directory

    def initialize(tree = nil, output_dir = nil)
      @tree = tree || LonelyPlanet::TaxonomyTree.new
      @template = File.dirname(__FILE__) + '/templates/example.html.erb'
      @output_directory = output_dir || '.'
      raise "Directory: #{@output_directory} does not exist" unless File.exist?(@output_directory)
    end
    def parse(file)
      raise "File #{file} does not exist" unless File.exist?(file)

      parser = Saxerator.parser(File.new(file))
      renderer = LonelyPlanet::Renderer.new(@template)

      parser.for_tag(:destination).each do |d|
        if (d["introductory"] &&
            d["introductory"]["introduction"] &&
            d["introductory"]["introduction"]["overview"])
          overview = d["introductory"]["introduction"]["overview"]
        else
          overview = ''
        end
        destination = LonelyPlanet::Destination.new({
          id: d.attributes["atlas_id"].to_i,
          overview: overview
        })
        if destination.id.nil?
          puts "Skipping #{d.attributes['title']} - No atlas_id"
          next
        end
        node = @tree.node(destination.id)

        # set desination atttributes
        destination.name = node.name
        destination.path = @tree.path(node)
        destination.details = generate_details(d)
        destination.breadcrumbs = generate_breadcrumbs(@tree.ancestors(node)) if node.parent
        destination.subnav = generate_subnav(node.children)

        if (d['history'] &&
            d['history']['history'] &&
            d['history']['history']['overview'])
          destination.history = d['history']['history']['overview']
        end

        render(destination, renderer)
      end
    end

    def render(destination, renderer = nil, save_to_file = true)
      renderer ||= LonelyPlanet::Renderer.new(@template)
      output =  renderer.render(destination)
      if save_to_file
        # save the output to a file
        path = @output_directory + destination.path
        begin
          FileUtils.mkdir_p(File.dirname(path))
          file = File.open(path, 'w')
          file.write(output)
        ensure
          file.close
        end
      else
        output
      end
    end

    # Returns array of hashes to generate menu of details for a destination
    # {category => [subcategories]}
    # {category => [{subcat => [subsub]}]
    def generate_details(d)
      details = d.inject({}) { |res, (k,v)|
        res[k] = v.keys.map{|kk|
          if v[kk].is_a?(Hash)
            {kk => v[kk].keys}
          else
            {kk => nil }
          end
        }
        res
      }
      details.delete('history')
      details.delete('introductory')
      details
    end

    # generate array for breadcrumb navigation
    # [['name', 'path'],['name',path']
    def generate_breadcrumbs(ancestors)
      return nil if ancestors.nil?
      ancestors.map{ |a|
        [a.name, @tree.path(a)]
      }
    end

    # subnav
    # list of destinations that fall under the current destination
    #[['name','path']['name','path']]
    def generate_subnav(children)
      children.map{ |c|
        node = @tree.node(c)
        [node.name, @tree.path(node)]
      }
    end
  end
end
