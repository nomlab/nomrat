# -*- coding: utf-8 -*-
module NomnichiBot
  module Reporter
    class Nomnichi

      def report
        return nil unless article = Scrap.open(:nomnichi).last
        msg = "次のノムニチ担当は #{next_author(article.author)} さんです．"

        if (ago = (Date.today - article.date).to_i) >= 7
          msg << "最後の記事(#{ago}日前)から1週間以上経ってますよ？"
        end

        return msg
      end

      private

      def next_author(author)
        author_order = {
          "nom"       => "kitagawa",
          "kitagawa"  => "danjo-m",
          "danjo-m"   => "nakao",
          "nakao"     => "murata",
          "murata"    => "okada",
          "okada"     => "kitagaki",
          "kitagaki"  => "masuda-y",
          "masuda-y"  => "ikeda-y",
          "ikeda-y"   => "ichikawa",
          "ichikawa"  => "kobayashi",
          "kobayashi" => "nakamura",
          "nakamura"  => "fujita",
          "fujita"    => "nom"
        }
        author_order[author] || "??"
      end

    end # class Nomnichi
  end # module Reporter
end # module NomnichiBot
