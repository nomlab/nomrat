# -*- coding: utf-8 -*-
## Create   : 2011/06/09 -Y.Kimura
## Modified : 2013/04/11 -Y.kimura
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
require 'DebiansecGetter.rb'
require 'CalendarGetter.rb'
## others
require 'time'
require 'date'
$KCODE = "UTF8"
#####################


### initialize
error_message = ""
tweetsender = TweetSender.new
mailsender = MailSender.new

##----------------------------------------------------------------------
## Tweet next Nomnichi author
##----------------------------------------------------------------------
begin
  nomnichigetter = NomnichiGetter.new
  writer_message = nomnichigetter.get_writer
  
  if( writer_message == "" )
    error_message << "[nom_bot.rb/nomnichi_author]\n"
  else
    tweetsender.send_message( writer_message )
  end
rescue
  error_message << "I cannot get nomnichi articles"
end

##----------------------------------------------------------------------
## Tweet Kinro title
##----------------------------------------------------------------------
if(Time.now.wday == 5) ## today is Friday???
  kinrogetter = KinroGetter.new
  kinro_message = kinrogetter.get_kinro

  if( kinro_message == "" )
    error_message << "[nom_bot.rb/kinro_title]\n"
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
    error_message << "[nom_bot.rb/redmine_ticket]\n"
else
  tweetsender.send_message( redmine_message )

  if( redminegetter.itr_date - Date.today == 2 )
    redmine_ticket = redminegetter.get_ticket
    itr = redminegetter.new_itr
                     # body        , setting file       , _                 , _        , parameter
    mailsender.send( redmine_ticket, "_redmine_mail.stg", host = "localhost", port = 25, itr )
  end
end

##----------------------------------------------------------------------
## Mail Debian's security message
##----------------------------------------------------------------------
debiansecgetter = DebiansecGetter.new
debiansec_message = debiansecgetter.get_sec

if( debiansec_message != [] )
  head = "Debianに，以下のパッケージのセキュリティ勧告が報告されています．\n"
  head << "================================================================\n"
  body = head + debiansec_message.to_s
                  # body, setting file       , _                 , _        , parameter
  mailsender.send( body, "_debiansec_mail.stg", host = "localhost", port = 25, "#{Date.today.to_s}" )
  
end

##----------------------------------------------------------------------
## Notice weather
##----------------------------------------------------------------------
weathergetter = WeatherGetter.new
weather_message = weathergetter.notice_rain(weathergetter.get_weather)

if( weather_message == nil)
  error_message << "[nom_bot.rb/weather]\n"
else
  tweetsender.send_message( weather_message )
end

## Calendar message
##----------------------------------------------------------------------
calendar_messenger = CalendarMessenger.new
calendar_message = calendar_messenger.create_meeting_reminder
##----------------------------------------------------------------------

if( calendar_message == "" )
    error_message << "[nom_bot.rb/calendar]\n"
else
  tweetsender.send_message( calendar_message )
end
##----------------------------------------------------------------------
## Write errorlog
##----------------------------------------------------------------------
