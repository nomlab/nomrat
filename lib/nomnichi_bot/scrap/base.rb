module NomnichiBot
  module Scrap
    class Base
      attr_reader :articles

      class Article
        attr_reader :content

        def initialize(date, content)
          @date, @content = date, content
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      def initialize(config = nil)
        @articles = create_articles(fetch_content(config))
      end

      def each
        @articles.each do |a|
          yield a
        end
      end

      def today
        @articles.find {|a| a.respond_to?(:date) and a.date == Date.today}
      end

      def last
        @articles.sort {|a,b| a.date <=> b.date}.last
      end

      private

      def create_articles(content)
        return [Article.new(Date.today, content)]
      end

      def fetch_content(config = nil)
        login(config) if config
        open(page_url).read
      end

      def login(config)
      end

      def page_url
        self.class.const_get(:PAGE_URL)
      end

    end # class Base
  end # module Scrap
end # module NomnichiBot
