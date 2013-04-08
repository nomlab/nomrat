# -*- coding: utf-8 -*-
## Created  : 2011/10/31 -Y.Kimura
## Modified : 2012/11/01 -Y.Kimura
## Ruby Ver : 1.8.7
## Inform next Itr by mail
#####################
require 'Tweet.rb'
require 'AttentionMail.rb'
require 'rubygems'
require 'open-uri'
require 'time'
require 'date'
$KCODE = "UTF8"
#####################

##----------------------------------------------------------------------
## read Tweet class
##----------------------------------------------------------------------

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

##----------------------------------------------------------------------
## set the recent Itr page
##----------------------------------------------------------------------

### GET next_itr
sours = ""
redmine_page = "http://redmine.swlab.cs.okayama-u.ac.jp/projects/lastnote"

begin
  open( redmine_page ){|f|
    f.each_line{|line|
      sours += line
    }
  }
rescue
  error_message << "Error: fail to GET redmine/lastnote.\n"
end

### GET newItr from redmine
itr_page = ""
new_itr = Array.new
new_itr = sours.scan( /class=\"wiki\-page\">最新イテレーション\s\((Itr[\d]*)\)/ )
if( new_itr != [])
  itr_page = redmine_page + "/wiki/" + new_itr.first.to_s
else
  error_message << "Error: fail to make itr_address.\n"
end

### SET sours
sours = ""
begin
  open( itr_page ){|f|
    f.each_line{|line|
      sours += line
    }
  }
rescue
  error_message << "Error: fail to GET redmine/next_meeting.\n"
end


##----------------------------------------------------------------------
## set next meeting date and author
##----------------------------------------------------------------------

### Set next_date
itr_note = ""
date_next = nil
date_before = nil
writer = nil

sours.each {|line|
  itr_note = line 
  break if(line =~ /期間/)
}

begin
  if(itr_note =~ /期間[:|：][\s]*([\d]+\-[\d]+\-[\d]+)[^\d]*([\d]+\-[\d]+\-[\d]+)/)
    date_before = $1
    date_next = $2
  end
  if(itr_note =~ /書記[:|：][\s]*([^<]*)/)
    writer = $1
  end
rescue
  error_message << "Error: fail to set next meeting date.\n"
end

date_arr = date_next.split("-")

date_itr = Date.new( date_arr[0].to_i, date_arr[1].to_i, date_arr[2].to_i )

=begin

date_next = nil
begin
  content_next = sours.scan( /<p>次回\s?<br \/>([^<]*)<br \/>/ ).first
  /([\d]*)年([\d]*)月([\d]*)日/ =~ content_next.first
  next_year = $1.to_i + 1988
  next_month = $2.to_i
  next_day = $3.to_i
  date_next = Date.new( next_year, next_month, next_day )
rescue
  date_next = Date.new( 2012,10,31 ) # 
end

date_itr = nil
begin
  content_next = sours.scan( /<p>日時：[\s]*([^<]*)<br \/>/ ).first
  /([\d]*)年([\d]*)月([\d]*)日/ =~ content_next.first
  itr_year = $1.to_i + 1988
  itr_month = $2.to_i
  itr_day = $3.to_i
  date_itr = Date.new( itr_year, itr_month, itr_day )
rescue
  error_message << "Error: fail to set next meeting date.\n"
end

=end


### tweet attention
speach = ""

if(date_itr - Date.today == 3)
  speach = "GN開発打合せ3日前です．書記の#{writer}さんは今イテレーションのwikiのページを確認してください．->(#{itr_page})"
end
if(date_itr - Date.today == 2)
  speach = "GN開発打合せ2日前です．GNグループの皆様は各自チケットの更新を確認してください．"
end

### output error message
if( error_message == "" )
  tm.send_message( speach ) unless(speach == "")
else
  errors = Time.now.strftime("%Y/%m/%d : ") + "\n"
  open("errorlog.txt", "w+"){|f|
    errors << error_message
    f.write errors
  }
end

 exit unless(date_itr-Date.today == 2)

#####----------------------------------------------------------------------
##### SEND MAIL
#####----------------------------------------------------------------------

### Set non_updated ticket

/<p>\(更新なし\)(.*)<\/p>/ =~ sours
string_non_updateds = $1.to_s
non_updateds = Array.new
non_updateds = string_non_updateds.scan( /br \/><a href=\"[^\"]*\" class=\"[^\"]*\" title="[^\"]*">#([\d]+)<\/a>([^<]*)</ )

mail_message = ""
non_updateds.each{|elem|
  mail_message << "#" + elem[0] + " ( http://redmine.swlab.cs.okayama-u.ac.jp/issues/#{elem[0]} )\n"
  mail_message << "  " + elem[1] + "\n"
}

### Send mail to GN member
attention = AttentionMail.new
message = "GNグループの皆さまへ\n\n"
message << "GN開発打合せ2日前です．\n現在，更新なしのチケットは以下の通りです．\n\n"

if(mail_message == "")
  message << "・・・更新なしのチケットはありません．\n"
else
  message << "X_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/X\n"
  message << mail_message
  message << "X_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/X\n"
end

message << "\nなお，今イテレーションにおけるチケットに関しましては，以下をご参照ください．\n"
message << itr_page

attention.sendmail( message, new_itr.first.to_s )
