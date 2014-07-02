# -*- coding: utf-8 -*-
module NomnichiBot
  module Scrap
    class Calendar < Base

      class Article
        attr_reader :date, :summary

        def initialize(date, summary)
          @date, @summary = date, summary
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      private

      def create_articles(content)
        content.map do |e|
          Article.new(e.dtstart.to_date, e.summary)
        end
      end

      def fetch_content(config)
        config = Config.load(:google_calendar)
        gcal = GoogleCalendar.new(config)
        gcal.events(config["calendar_id"])
      end

    end # class Calendar
  end # module Scrap
end # module NomnichiBot
