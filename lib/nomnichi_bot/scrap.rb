require "open-uri"
require "date"
require "json"

module NomnichiBot
  module Scrap
    def self.nomnichi
      Nomnichi.new
    end

    def self.kinro
      Kinro.new
    end

    def self.weather
      Weather.new
    end

    dir = File.dirname(__FILE__) + "/scrap"
    autoload :Base,     "#{dir}/base.rb"
    autoload :Nomnichi, "#{dir}/nomnichi.rb"
    autoload :Kinro,    "#{dir}/kinro.rb"
    autoload :Weather,  "#{dir}/weather.rb"

  end # module Scrap
end # module NomnichiBot
