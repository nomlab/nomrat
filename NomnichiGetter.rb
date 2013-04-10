# -*- coding: utf-8 -*-
## Create   : 2011/06/09 -Y.Kimura
## Modified : 2013/4/10 -Y.kimura
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
    sours = ""
    nomnichi_page = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi"
    
    begin
      open( nomnichi_page ){|f|
        f.each_line{|line|
          sours += line
        }
      }
    rescue
      error_message << "Error: fail to Get nomnichi page.\n"
    end
    
    ### Get author&date from nomnichi
    speaker = Array.new
    author = nil
    last_date = nil
    
    begin
      ## next date
      date_array = sours.scan( /<div class=\"published_on\">\s([^\n]*)\n/ )
      author = sours.scan( /<div class=\"published_on\">\s.*\s([^<]*)\s.*\s<\/div>/ )
      author.flatten!
      last_date = date_array.flatten.first.strip
      ## next author
      author.each do |name|
        name.strip!
        speaker << nom_table[name] if( nom_table[name] != nil)
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
