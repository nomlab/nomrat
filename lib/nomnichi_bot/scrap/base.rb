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
        @articles = create_articles(page_content(page_url, config))
      end

      def today
        @articles.find {|a| a.respond_to?(:date) and a.date == Date.today}
      end

      def last
        @articles.sort {|a,b| a.date <=> b.date}.last
      end

      private

      def page_url
        self.class.const_get(:PAGE_URL)
      end

      def page_content(url, config = nil)
        login(config) if config
        content(url)
      end

      def login(config)
      end

      def content(url)
        open(url) do |f|
          f.read
        end
      end

      def create_articles(content)
        return [Article.new(Date.today, content)]
      end

    end # class Base
  end # module Scrap
end # module NomnichiBot
