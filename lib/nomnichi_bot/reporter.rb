module NomnichiBot
  module Reporter
    def self.nomnichi
      Nomnichi.new
    end

    def self.tvshow
      Tvshow.new
    end

    def self.weather
      Weather.new
    end

    dir = File.dirname(__FILE__) + "/reporter"
    autoload :Nomnichi, "#{dir}/nomnichi.rb"
    autoload :Tvshow,   "#{dir}/tvshow.rb"
    autoload :Weather,  "#{dir}/weather.rb"

  end # module Reporter
end # module NomnichiBot
