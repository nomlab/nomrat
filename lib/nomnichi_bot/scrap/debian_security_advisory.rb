module NomnichiBot
  module Scrap
    class DebianSecurityAdvisory < Base
      PAGE_URL = "https://www.debian.org/security/#{Date.today.year}/index.ja.html"

      class Article
        attr_reader :date, :title, :link

        def initialize(date, title, link)
          @date, @title, @link = date, title, link
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      private

      def create_articles(content)
        regexp = /<tt>\[([\d-]+)\].*href="\.([^"]+)">([^<]+)</
        content.scan(regexp).map do |date, link, title|
          link = File.dirname(PAGE_URL) + link
          Article.new(date, title, link)
        end
      end

    end # class DebianSecurityAdvisory
  end # module Scrap
end # module NomnichiBot
