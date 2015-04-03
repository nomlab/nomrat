module Nomrat
  module Scrap
    class Kinro < Base
      PAGE_URL = "https://kinro.jointv.jp/lineup/list/"

      class Article
        attr_reader :date, :title

        def initialize(date, title)
          @date, @title = date, title
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      private

      def create_articles(content)
        regexp = /movie_data">([\d.]+)<.*?movie_tit">([^<]+)</m
        content.scan(regexp).map do |date, title|
          Article.new(date, title)
        end
      end

    end # class Kinro
  end # module Scrap
end # module Nomrat
