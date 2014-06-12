# -*- coding: utf-8 -*-

## Created:  2011-06-09 - Y.Kimura

require 'open-uri'
require 'date'

class NomnichiGetter
  PAGE_URL = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi"

  class Article
    attr_reader :date, :author

    def initialize(date, author)
      @date, @author = date, author
      @date = Date.parse(date) if date.is_a?(String)
    end
  end # class Article

  def get_writer
    last_article = last_article(articles(page_content(PAGE_URL)))

    script = "次のノムニチ担当は #{next_author(last_article.author)} さんです．よろしくお願いします．"

    if Date.today - last_article.date >= 7
      script << "最後の記事(#{date_ago}日前)から1週間以上経ってますよ？"
    end
    return script
  end

  private

  def page_content(url)
    open(url) do |f|
      f.read
    end
  end

  def articles(content)
    content.scan(/>(\d{4}-\d{2}-\d{2}) +([\da-z-]+)</).map do |date, author|
      Article.new(date, author)
    end
  end

  def last_article(articles)
    articles.sort {|a,b| a.date <=> b.date}.last
  end

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
end # class NomnichiGetter
