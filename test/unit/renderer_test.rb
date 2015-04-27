require 'minitest/autorun'
require 'test_helper'

class RendererTest < MiniTest::Test
  def setup
    @render = LonelyPlanet::Renderer.new('lib/lonely_planet/templates/example.html.erb')
  end

  def test_true
    assert true
  end

  def test_assert_respond_to_template
    assert_respond_to @render, :template
  end

  def test_assert_shouls_raise_if_file_not_exists
    assert_raises (RuntimeError) {LonelyPlanet::Renderer.new('not_a_file')}
  end
end

