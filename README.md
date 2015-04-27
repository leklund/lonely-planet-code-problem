## Lonely Planet Coding Challenge

### Quickstart

__requirements__

ruby:

Written and tested with 2.2.1. Also tested on 2.1 so it should work on >= 2.0.

gems:

* nokogiri
* saxerator
* minitest

Running `bundle install` from the root directory of the project will install these.

__running the tests__

Ensure everything is working properly (bundle exec to get the
right minitest is needed for olfer rubies).

    bundle exec rake test

__invoking the generator__

```
> ruby page_generator  -h
Usage: page_generator.rb [OPTIONS]
    -t, --taxonomy FILE              XML file that contains the destination taxonomy (required)
    -d, --destinations FILE          XML file that contains all the destinations to be generated (required)
    -o, --output DIRECTORY           Directory that output HTML files will be saved in (required)
    -h, --help                       Show this message
```

To run on the provided sample data

```
> mkdir tmpout
> ruby page_generator.rb -t test/fixtures/taxonomy.xml -d test/fixtures/destinations.xml -o tmpout
```

__view the output__

I included a config.ru file that points to the tmpout directory so you should be able to just run

```
> rackup
```

which should start a thin or webrick instance. For thin you should now see content at

http://localhost:9292/africa.html

## Components

#### LonelyPlanet::TaxonomyTree

Class for creating a model of the XML taxonomy in ruby. Provides methods
for returning a node, finding a node's ancestors, adding nodes, and
generating the path to a node.

#### LonelyPlanet::TaxonomyNode

Class for individual node entries that make up a TaxonomyTree.
Attributes: id, name, parent, children.

#### LonelyPlanet::TaxonomyParser

This is an subclass of Nokogiri::XML::SAX::Document and provides methods
for parsing the taxonomy.file. The most useful attribute is tree which is an
instance of LonelyPlanet::TaxonomyTree that is generated as the parser runs.
This is used with Nokogiri::XML::SAX::Parser to parse an XML file.

```
doc = LonelyPlanet::TaxonomyParser.new
parser = Nokogiri::XML::SAX::Parser.new(doc)
parser.parse_file('taxonomy.xml')
doc.tree  #=> returns a populated LonelyPlanet::TaxonomyTree
```

#### LonelyPlanet::Destination

Class that holds all the attributes for a given destination.

#### LonelyPlanet::DestinationParser

This class offers methods for parsing and rendering a destination XML file. It uses the saxerator
gem to parse tags in chunks. For each destination element in the XML it will create a LonelyPlanet::Destination,
populate that object with attributes, and attempt render to an html file.

This class is initialized with a LonelyPlanet::TaxonomyTree, and an output directory. The template path can also
be overridden after an instance is created.

#### LonelyPlanet::Renderer

A simple ERB rendering class.


---
Lukas Eklund
lukas@eklund.io
