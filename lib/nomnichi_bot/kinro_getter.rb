# -*- coding: utf-8 -*-

## Created: 2011-06-09
## Authors: Y.Kimura, Yoshinari Nomura

require 'rubygems'
require 'open-uri'
require 'kconv'
require 'time'
require 'date'

class KinroGetter
  PAGE_URL = "https://kinro.jointv.jp/lineup/list/"

  class Article
    attr_reader :date, :title

    def initialize(date, title)
      @date, @title = date, title
      @date = Date.parse(date) if date.is_a?(String)
    end
  end # class Article

  def get_kinro(date = Date.today)
    article = articles(page_content(PAGE_URL)).find {|a| a.date == date}
    return nil unless article
    return "本日(#{date})の金曜ロードショーは #{article.title.toutf8} です．皆様早く帰りましょう．"
  end

  private

  def page_content(url)
    open(url) do |f|
      f.read
    end
  end

  def articles(content)
    regexp = /movie_data">([\d.]+)<.*?movie_tit">([^<]+)</m
    content.scan(regexp).map do |date, title|
      Article.new(date, title)
    end
  end

  def last_article(articles)
    articles.sort {|a,b| a.date <=> b.date}.last
  end
end # class KinroGetter
