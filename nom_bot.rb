# -*- coding: utf-8 -*-
## Create   : 2011/06/09 -Y.Kimura
## Modified : 2012/12/13 -Y.kimura
## Ruby Ver : 1.8.7
## Inform Nomnichi author by tweet
#####################
require 'Tweet.rb'
require 'NomTable.rb'
require 'rubygems'
require 'open-uri'
require 'kconv'
require 'time'
require 'date'
$KCODE = "UTF8"
#####################

##----------------------------------------------------------------------
## main
##----------------------------------------------------------------------

## Next writer table (member)
## 
nom_table = NomTable.new.nom_table

### Authorize
error_message = ""

begin
  tm = Tweet.new
rescue
  error_message << "Error: fail to Authorize.\n"
end

### Simple tweet from command line input
line_message = ARGV[0]
if(line_message != nil)
  tm.send_message( line_message )
  exit
end

### GET nomnichi
sours = ""
nomnichi_page = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi"

begin
  open( nomnichi_page ){|f|
    f.each_line{|line|
      sours += line
    }
  }
rescue
  error_message << "Error: fail to GET nomnichi.\n"
end

### GET author&date from nomnichi
speaker = Array.new
author = nil
last_date = nil

begin
  date_array = sours.scan( /<div class=\"published_on\">\s([^\n]*)\n/ )
  author = sours.scan( /<div class=\"published_on\">\s.*\s([^<]*)\s.*\s<\/div>/ )
  author.flatten!
  last_date = date_array.flatten.first.strip
rescue
  error_message << "Error: fail to GET author&date from nomnichi.\n"
end

### define next author
author.each do |name|
  name.strip!
  if( nom_table[name] != nil)
    speaker << nom_table[name]
  end
end

error_message << "Error: fail to define next author.\n" if speaker.first == nil

### tweet next author
speach = "次のノムニチ担当は#{speaker.first}さんです．よろしくお願いします．"
week_ago = (Time.now - 7*24*60*60)
date_ago = (Time.now - Time.parse(last_date) ).to_i / (60*60*24)

speach << "最後の記事(#{date_ago}日前)から1週間以上経ってますよ？" if( week_ago > Time.parse(last_date) )

if( error_message == "" )
  ret = tm.send_message( speach )
else
  errors = Time.now.strftime("%Y/%m/%d : ") + "\n"
  open("errorlog.txt", "w+"){|f|
    errors << error_message
    f.write errors
  }
end


### 卒論締切まで・・・

today = Date.today
sotsu = ( Date.new(2013,2,8) - today ).to_s

speach = "卒論締切(2/8)まであと#{sotsu}日です！予定を管理して無理のない執筆を！"
tm.send_message( speach )

###


## 金曜日じゃないなら終わるね
exit unless (Time.now.wday == 5)

##----------------------------------------------------------------------
## 金曜ロードショー
##----------------------------------------------------------------------

sours = ""
kinro_error = ""
broad_fri = Time.now.strftime("%Y%m%d")
url = "http://www.ntv.co.jp/kinro/lineup/#{broad_fri}/index.html"

begin
  open( url ) {|f|
    f.each_line do |line|
      sours = line
      break if( line =~ /<h1 class="text-off-screen">/ )
    end
  }
rescue
  kinro_error << "Error: fail to GET kinro page."
end

speach = ""
begin
  sours =~ ( />([^<]*)</ )
  kinro = $1.toutf8
  speach = "本日は金曜日です．金曜ロードショーは「#{kinro}」です．皆様早く帰りましょう．" unless kinro == nil
rescue
  kinro_error << "Error: fail to make speach message"
end

if( kinro_error == "" )
  tm.send_message( speach )
else
  open("errorlog.txt", "w+"){|f|
    f.write kinro_error
  }
end
