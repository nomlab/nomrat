# -*- coding: utf-8 -*-
module NomnichiBot
  module Reporter
    class Weather

      def report
        return nil unless weather = NomnichiBot::Scrap.weather.today
        msg = "今日のお天気は#{weather.telop}です!"
        msg << "傘を忘れずに持ってきましょう!" if /雨/ =~ weather.telop
        return msg
      end

    end # class Weather
  end # module Reporter
end # module NomnichiBot
