# -*- coding: utf-8 -*-

#
# Weather information scaper
# http://weather.livedoor.com/weather_hacks/webservice
#
module Nomrat
  module Scrap
    class Weather < Base
      PAGE_URL = "http://weather.livedoor.com/forecast/webservice/json/v1?city=330010"

      class Article
        attr_reader :date, :date_label, :telop

        def initialize(date, date_label, telop)
          @date, @date_label, @telop = date, date_label, telop
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      def today
        forecast("今日")
      end

      def tomorrow
        forecast("明日")
      end

      def day_after_tomorrow
        forecast("明後日")
      end

      private

      def forecast(date_label)
        @articles.find {|forecast| forecast.date_label == date_label}
      end

      def create_articles(content)
        JSON.parse(content)["forecasts"].map do |f|
          Article.new(f["date"], f["dateLabel"], f["telop"])
        end
      end

    end # class Weather
  end # module Scrap
end # module Nomrat
