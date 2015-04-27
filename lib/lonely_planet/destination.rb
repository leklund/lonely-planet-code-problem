module LonelyPlanet
  class Destination
    attr_accessor :id, :name, :path, :overview, :details, :breadcrumbs, :subnav, :menu, :data, :history

    def initialize(hash= {})
      hash.each do |k,v|
        self.send("#{k.to_s}=", v) if self.respond_to?(k.to_sym)
      end
    end

    def get_binding
      binding()
    end
  end
end
