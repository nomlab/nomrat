# -*- coding: utf-8 -*-
module Nomrat
  module Reporter
    class Nomnichi

      def report
        return nil unless articles = Scrap.open(:nomnichi).articles

        author = next_author(articles)
        last_article = last_article(author, articles)

        msg = "次のノムニチ担当は #{author} さんです．"

        if !last_article
          msg << "ここ最近，あなたの記事を見ていませんよ？"
        elsif (ago = (Date.today - last_article.date).to_i) >= 7
          msg << "最後のあなたの記事(#{ago}日前)から随分経ってますよ？"
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

      def next_author(articles)
        candidates = authors

        articles.sort {|a,b| b.date <=> a.date}.each do |article|
          break if candidates.length < 2
          candidates.delete(article.author)
        end
        return candidates.shift
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
