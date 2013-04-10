# -*- coding: utf-8 -*-
## Create   : 2011/06/09 -Y.Kimura
## Modified : 2013/04/10 -Y.kimura
## Ruby Ver : 1.8.7
## Inform Nomnichi author by tweet
#####################
## sender class
require 'TweetSender.rb'
require 'MailSender.rb'
## getter class
require 'NomnichiGetter.rb'
require 'KinroGetter.rb'
require 'RedmineGetter.rb'
## others
require 'time'
require 'date'
$KCODE = "UTF8"
#####################



### Authorize
error_message = ""
tweetsender = TweetSender.new

##----------------------------------------------------------------------
## Tweet next Nomnichi author
##----------------------------------------------------------------------
nomnichigetter = NomnichiGetter.new
writer_message = nomnichigetter.get_writer

if( writer_message == "" )
  puts ""
else
  tweetsender.send_message( writer_message )
end

##----------------------------------------------------------------------
## Tweet Kinro title
##----------------------------------------------------------------------
if(Time.now.wday == 5) ## today is Friday???
  kinrogetter = KinroGetter.new
  kinro_message = kinrogetter.get_kinro

  if( kinro_message == "" )
    puts "error of kinro"
  else
    tweetsender.send_message( kinro_message )
  end
end

##----------------------------------------------------------------------
## Tweet GNgroups meeting and Mail Tickets
##----------------------------------------------------------------------
redminegetter = RedmineGetter.new
redmine_message = redminegetter.get_itr

if( redmine_message == "" )
  puts ""
else
  tweetsender.send_message( redmine_message )

  if( redminegetter.itr_date - Date.today == 2 )
    redmine_ticket = redminegetter.get_ticket
    itr = redminegetter.new_itr

    mailsender = MailSender.new
    mailsender.send( redmine_ticket, "_redmine_mail.stg", host = "localhost", port = 25, itr )
  end
end


##----------------------------------------------------------------------
## Write errorlog
##----------------------------------------------------------------------
