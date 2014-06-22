module NomnichiBot
  module Scrap
    class Nomnichi < Base
      PAGE_URL = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi"

      class Article
        attr_reader :date, :author

        def initialize(date, author)
          @date, @author = date, author
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      private

      def create_articles(content)
        content.scan(/>(\d{4}-\d{2}-\d{2}) +([\da-z-]+)</).map do |date, author|
          Article.new(date, author)
        end
      end

    end # class Nomnichi
  end # module Scrap
end # module NomnichiBot
