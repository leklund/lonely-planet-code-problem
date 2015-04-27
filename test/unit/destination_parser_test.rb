require 'minitest/autorun'
require 'test_helper'

class DestinationParserTest < MiniTest::Test
  def setup
    doc = LonelyPlanet::TaxonomyParser.new
    tax_parser = Nokogiri::XML::SAX::Parser.new(doc)
    tax_parser.parse_file('test/fixtures/taxonomy_sample.xml')
    @tree = doc.tree
    @parser = LonelyPlanet::DestinationParser.new(@tree)
  end

  def test_should_respond_to_parse
    assert_respond_to @parser, :parse
  end

  def test_should_respond_to_tree
    assert_respond_to @parser, :tree
  end

  def test_parser_should_respond_to_template
    assert_respond_to @parser, :template
  end

  def test_parse_should_repond_to_output_dir
    assert_respond_to @parser, :output_directory
  end

  def test_parse_should_repond_to_render
    assert_respond_to @parser, :render
  end

  def test_parser_should_initialize_with_taxonomy_tree
    assert_kind_of LonelyPlanet::TaxonomyTree, @parser.tree
  end

  def test_parse_validates_file_exists
    assert_raises(RuntimeError) { @parser.parse('non-existent-file') }
  end

  def test_generate_details_has
    details = @parser.generate_details(sample_dest_hash)
    assert_kind_of Hash, details
  end

  def test_generate_details_has_expected_output
    details = @parser.generate_details(sample_dest_hash)
    expected = {
      "transport" => [
        {"getting_around" => ["overview"]},
        {"getting_there_and_away" => ["bus_and_tram"]}
      ]
    }
    assert_equal expected, details
  end

  def test_parser_should_respond_to_generate_breadcumbs
    assert_respond_to @parser, :generate_breadcrumbs
  end

  def test_generate_breadcrumbs
    node = @tree.node(355612)
    crumbs = @parser.generate_breadcrumbs(@tree.ancestors(node))
    exected = [['Africa','/africa.html'],['South Africa', '/africa/south_africa.html']]
    assert_equal exected, crumbs
  end

  def test_breadcrumbs_for_root_node_should_be_nil
    node = @tree.node(355064) # Africa
    crumbs = @parser.generate_breadcrumbs(@tree.ancestors(node))
    assert_nil crumbs
  end

  def test_parser_should_respond_to_generate_subnav
    assert_respond_to @parser, :generate_subnav
  end

  def test_generate_subnav
    node = @tree.node(355064) # Africa
    subnav = @parser.generate_subnav(node.children)
    exected = [['South Africa', '/africa/south_africa.html'],['Sudan','/africa/sudan.html'],
               ['Swaziland','/africa/swaziland.html'],["Ampersand & Test", "/africa/ampersand___test.html"]]
    assert_equal exected, subnav
  end

  def test_render_method_with_save_file_false
    node = @tree.node(355612)
    d = sample_dest_hash
    destination = LonelyPlanet::Destination.new({id: node.id, overview: d["history"]["history"]["overview"]})
    destination.name = node.name
    destination.details = @parser.generate_details(d)
    destination.breadcrumbs = @parser.generate_breadcrumbs(@tree.ancestors(node)) if node.parent
    destination.subnav = @parser.generate_subnav(node.children)
    output = @parser.render(destination, nil, false)

    assert_match node.name, output
    assert_match 'foobar', output
  end

  def sample_dest_hash
    {"history" =>
     {"history" =>
      { "history" => ["foo","bar","baz"],
        "overview" =>"foobar" 
      }},
      "introductory" => 
      {"introduction"=>
       {"overview"=>"Built where the two Niles meet, Khartoum is one of the more modern cities in Central Africa, with paved roads, high-rise buildings and all the services you might want or need. Some travellers consider it nothing but a dusty, congested and joyless (nightlife is nearly nonexistent) stopover. But those looking to uncover its culture will appreciate what they find when they start walking around. Besides, its people are hospitable, the riverside setting is attractive and it’s one of the safest cities in Africa – so for one reason or another most people end up liking it here."}},
      "transport"=>
       {"getting_around"=>
        {"overview"=>"Buses (SDD40 to SDD80) and minibuses (SDD100) cover most points in Khartoum and run very early to very late. Taxi prices (and if they have no passengers the minibuses work like taxis and often cost less) are negotiable: expect to pay around SDD400 to SDD500 for journeys within the city centre and SDD800 to destinations within greater Khartoum. For shorter trips (except in central Khartoum) there are also motorised rickshaws, which should cost no more than SDD300.The short ride by taxi from Khartoum airport to the city centre is unofficially fixed at SDD2500, though you can sometimes bargain this down. Better yet, try sharing the ride."},
        "getting_there_and_away"=>
          {"bus_and_tram"=>"Most road transport departs from one of four bus stations. Almost everything rolling south, east and west, including El-Obeid, Gederaf, Kassala and Port Sudan, goes from the modern and chaotic mina bary (land port) near Souq Mahali in southern Khartoum. The Sajana bus station serves Dongola and Wadi Halfa; Karima and Merowe buses use Omdurman’s Souq esh-Shabi; and the Atbara Bus Station is in Bahri."}}}
  end
  #Destination


end

