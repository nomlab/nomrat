# -*- coding: utf-8 -*-
module Nomrat
  module Reporter
    class Nomnichi

      def report
        return nil unless articles = Scrap.open(:nomnichi).articles

        msg = "ノムニチを書いてくれませんか．"

        next_authors(articles, 2).each do |author|
          last_article = last_article(author, articles)

          msg << "#{author} さん，"

          if !last_article
            msg << "たなたの記事を随分見ていません．"
          elsif (ago = (Date.today - last_article.date).to_i) >= 7
            msg << "最後の記事(#{ago}日前)から随分経ってますよ．"
          end

          msg << "\n"
        end

        return msg
      end

      private

      def authors
        return %w(
           nom
           okada kitagaki masuda-y
           ikeda-y ichikawa kobayashi nakamura fujita
           emi suetake sugi date yoshida-h
        )
      end

      def sort_authors_by_article_date(authors, articles)
        authors.sort do |author_a, author_b|
          a = last_article(author_a, articles)
          b = last_article(author_b, articles)

          if a && b
            a.date <=> b.date
          elsif !a && b
            -1
          elsif a && !b
            1
          else # !a && !b
            0
          end
        end
      end

      def next_authors(articles, max_authors = 1)
        sort_authors_by_article_date(authors, articles).take(max_authors)
      end

      def last_article(author, articles)
        articles.sort {|a,b| b.date <=> a.date}.each do |article|
          return article if article.author == author
        end
        return nil
      end

    end # class Nomnichi
  end # module Reporter
end # module Nomrat
