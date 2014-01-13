# -*- coding: utf-8 -*-
## Create   : 2011/06/09 -Y.Kimura
## Modified : 2013/04/10 -Y.kimura
## Ruby Ver : 1.8.7
## Get&Return Nomnichi author for tweet
#####################
require 'NomTable.rb'
require 'rubygems'
require 'open-uri'
require 'kconv'
require 'time'
require 'date'
$KCODE = "UTF8"
#####################

class NomnichiGetter

  def initialize
  end

  def get_writer
  ##----------------------------------------------------------------------
  ## main
  ##----------------------------------------------------------------------

    ### Read next writer table (member)
    error_message = ""
    
    begin
      nom_table = NomTable.new.nom_table
    rescue
      error_message << "Error: fail to Read next nomnichi writer.\n"
    end
    
    ### Get nomnichi page
    # nomnichi_page = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi/articles"
    sours = ""
    nomnichi_page = "http://tsubame.swlab.cs.okayama-u.ac.jp:54323/nomnichi"
    uri = URI.parse( nomnichi_page )
    file = "_nomnichi_cookie.stg"
    cookie_str = File.open(file,"r").read
    new_cookie = ""

    begin
      open( uri,{'Cookie'=>cookie_str} ){|f|
        f.each_line{|line|
          sours += line
        }
      new_cookie = f.meta
      }
    rescue
      error_message << "Error: fail to Get nomnichi page.\n"
    end

    is_cookie = (new_cookie.to_s =~ /set-cookie(.*)transfer-encodingchunked/)
    head = $1
    File.open(file,"w").write( head ) if (is_cookie != false)
    
    ### Get author&date from nomnichi
    speaker = Array.new
    author = nil
    last_date = nil
    
    begin
      article_list = sours.scan( /<li class=\"article_list\">([^<]*)<\/li>/ )

      ## next author
      article_list.each do |article|
        date_and_author = article.join("").split(" ")
        name = date_and_author.last
        name.strip!
        last_date = date_and_author.first
        speaker = nom_table[name] if( nom_table[name] != nil)
        break if( nom_table[name] != nil)
      end
      error_message << "Error: fail to Define next author.\n" if speaker.first == nil
      
    rescue
      error_message << "Error: fail to Get author&date from nomnichi.\n"
    end

    ### tweet next author
    speach = "次のノムニチ担当は#{speaker.first}さんです．よろしくお願いします．"
    week_ago = (Time.now - 7*24*60*60)
    date_ago = (Time.now - Time.parse(last_date) ).to_i / (60*60*24)
    
    speach << "最後の記事(#{date_ago}日前)から1週間以上経ってますよ？" if( week_ago > Time.parse(last_date) )
    
    if( error_message == "" )
      #ret = tm.send_message( speach )
      return speach
    else
      errors = Time.now.strftime("%Y/%m/%d : ") + "\n"
      open("errorlog.txt", "w+"){|f|
        errors << error_message
        f.write errors
      }
      return ""
    end
    
  end # method( get_writer ) end
  
end # class end
