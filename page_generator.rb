#!/usr/bin/env ruby

require 'optparse'
require_relative 'lib/lonely_planet'

options = {}

option_parser = OptionParser.new do |opts|
  opts.banner = 'Usage: page_generator.rb [OPTIONS]'
  opts.on("-t", "--taxonomy FILE", "XML file that contains the destination taxonomy (required)") do |arg|
    options[:taxonomy] = arg
  end
  opts.on("-d", "--destinations FILE", "XML file that contains all the destinations to be generated (required)") do |arg|
    options[:destinations] = arg
  end
  opts.on("-o", "--output DIRECTORY", "Directory that output HTML files will be saved in (required)") do |arg|
    options[:output] = arg
  end
  opts.on_tail("-h", "--help", "Show this message") do |arg|
    puts opts
    exit
  end
end
option_parser.parse!

# optparse doesn't support required switches so let's make sure
# we have all the required options and that the
# specified files and directory actually exist
show_help = false
[:taxonomy, :destinations, :output].each do |opt|
  if options[opt]
    unless File.exist?(options[opt])
      STDERR.puts "Error: File or directory #{options[opt]} does not exist!"
      show_help = true
    end
  else
    STDERR.puts puts "Error: missing required option #{opt.to_s}"
    show_help = true
  end
end
option_parser.parse(%w[-h]) if show_help


###
# Parse the taxonomy and get a LonelyPlanet::TaxonomyTree
#
doc = LonelyPlanet::TaxonomyParser.new
parser = Nokogiri::XML::SAX::Parser.new(doc)
parser.parse_file(options[:taxonomy])
tree = doc.tree

puts "Imported #{tree.nodes.keys.size} destinations from the taxonomy file."


###
# Parse the destinations file and output one html file per destination
#
destination_parser = LonelyPlanet::DestinationParser.new(doc.tree, File.expand_path(options[:output]))
destination_parser.parse(options[:destinations])

### The parser doesn't know or care about static files
#
FileUtils.cp_r Dir.glob('lib/lonely_planet/assets/*'), options[:output]

puts 'Website generation complete'
puts 'BYE!'
