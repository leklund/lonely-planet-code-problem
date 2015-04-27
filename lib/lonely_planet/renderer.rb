module LonelyPlanet
  class Renderer
    attr_reader :template

    def initialize(file)
      raise "file #{file} does not exist" unless File.exist?(file)
      @template = File.read(file)
    end

    def render(destination)
      renderer = ERB.new(@template, nil ,'<>-')
      renderer.result(destination.get_binding)
    end
  end
end
