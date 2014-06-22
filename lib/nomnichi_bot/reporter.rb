module NomnichiBot
  module Reporter

    def self.report(subject)
      reporters = {
        :nomnichi          => Nomnichi,
        :security_advisory => SecurityAdvisory,
        :tvshow            => Tvshow,
        :weather           => Weather
      }
      return reporters[subject].new.report if reporters[subject]
      raise ArgumentError, "unknown subject #{subject}"
    end

    dir = File.dirname(__FILE__) + "/reporter"
    autoload :Nomnichi,         "#{dir}/nomnichi.rb"
    autoload :SecurityAdvisory, "#{dir}/security_advisory.rb"
    autoload :Tvshow,           "#{dir}/tvshow.rb"
    autoload :Weather,          "#{dir}/weather.rb"

  end # module Reporter
end # module NomnichiBot
