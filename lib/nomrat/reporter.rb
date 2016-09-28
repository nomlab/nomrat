module Nomrat
  module Reporter

    def self.report(subject)
      reporters = {
        :calendar          => Calendar,
        :nomnichi          => Nomnichi,
        :security_advisory => SecurityAdvisory,
        :tvshow            => Tvshow,
        :weather           => Weather,
        :cleaner           => Cleaner,
      }
      return reporters[subject].new.report if reporters[subject]
      raise ArgumentError, "unknown subject #{subject}"
    end

    dir = File.dirname(__FILE__) + "/reporter"
    autoload :Calendar,         "#{dir}/calendar.rb"
    autoload :Nomnichi,         "#{dir}/nomnichi.rb"
    autoload :SecurityAdvisory, "#{dir}/security_advisory.rb"
    autoload :Tvshow,           "#{dir}/tvshow.rb"
    autoload :Weather,          "#{dir}/weather.rb"
    autoload :Cleaner,          "#{dir}/cleaner.rb"
  end # module Reporter
end # module Nomrat
