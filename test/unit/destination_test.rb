require 'minitest/autorun'
require 'test_helper'

class DestinationTest < MiniTest::Test
  def setup
    @dest = LonelyPlanet::Destination.new
  end

  def test_has_attributes
    assert_respond_to @dest, :name
    assert_respond_to @dest, :overview
    assert_respond_to @dest, :details
    assert_respond_to @dest, :path
    assert_respond_to @dest, :breadcrumbs
    assert_respond_to @dest, :subnav
    assert_respond_to @dest, :data
  end

  def test_new_sets_attrs_from_hash
    dest = LonelyPlanet::Destination.new({
      name: 'foo',
      overview: 'lorem ipsum',
      details: ['history','getting_there'],
      path: 'x/y'})
    assert_equal 'foo', dest.name
    assert_equal 'lorem ipsum', dest.overview
    assert_equal ['history','getting_there'], dest.details
    assert_equal 'x/y', dest.path
  end

  #
  # attrs
  #   name
  #   children node[]
  #   parent   node
  #
  #   overview (introductory -> introduction -> overview)
  #   history_overview (history -> history -> overview)
  #
  #   practical_inforamtion
  #     health_and_safety
  #       dangers_and_annoyances
  #     money_and_costs
  #       money
  #     visas
  #       other
  #       overview
  #
  #   transport
  #     getting_around
  #       air
  #       bicycle
  #       bus_tram
  #       car_and_motorcycle
  #       hitching
  #       local_transport
  #       overview
  #     getting_there_and_away
  #       air
  #       land
  #
  #   weather
  #     when_to_go
  #       climate
  #
  #   wildlife
  #     animals
  #       mammals
  #     birds
  #       overview
  #     endangered_species
  #       overview
  #     overview
  #       overview
  #     plants
  #       overview
  #
  #   work_live_study
  #     work
  #       business
  #       overview
  #
  # methods
  #
  # render -> passes self to erb template and saves to directory
  #   id_name.html
  #
  #   it should partion the files in the same heirarchy as teh taxonomy 1/4/5/6_joburg.html
  #    1/4/5_south_africa.html
  #    1/4_africa.html
  #    1/world.html if it existed
  #


end
