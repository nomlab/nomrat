require "open-uri"
require "date"
require "json"

module Nomrat
  module Scrap
    def self.open(scrap_name)
      scraps = {
        :calendar                 => Calendar,
        :debian_security_advisory => DebianSecurityAdvisory,
        :nomnichi                 => Nomnichi,
        :kinro                    => Kinro,
        :weather                  => Weather
      }
      if scraps[scrap_name]
        config = Config.load(scrap_name)
        return scraps[scrap_name].new(config)
      end
      raise ArgumentError, "unknown scrap #{scrap_name}"
    end

    dir = File.dirname(__FILE__) + "/scrap"
    autoload :Base,                   "#{dir}/base.rb"
    autoload :Calendar,               "#{dir}/calendar.rb"
    autoload :DebianSecurityAdvisory, "#{dir}/debian_security_advisory.rb"
    autoload :Nomnichi,               "#{dir}/nomnichi.rb"
    autoload :Kinro,                  "#{dir}/kinro.rb"
    autoload :Weather,                "#{dir}/weather.rb"

  end # module Scrap
end # module Nomrat
