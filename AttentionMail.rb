# -*- coding: utf-8 -*-
## Created  : 2012/10/31 -Y.Kimura
## Modified : 2012/12/11 -Y.Kimura
## Ruby Ver : 1.8.7
## Send EMail
##################
require 'nkf'
require 'net/smtp'
$KCODE = "UTF8"
##################

##---------------------------------------------------Class:send tweet
class AttentionMail

  def sendmail(body, itr, host = "localhost", port = 25)
    ## [To,From,Subject] in this file
    ## separated by "\n"
    f = open( "MailSetting.txt" ).read
    settings = f.split("\n")

    to   = settings[0]
    from = settings[1]
    subject = settings[2] + "(#{itr})"

    body = <<EOT
From: #{from}
To: #{to}
Subject: #{subject}
Date: #{Time::now.strftime("%a, %d %b %Y %X %z")}
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

#{NKF.nkf("-Wjm0", body)}
EOT

    Net::SMTP.start(host, port) do |smtp|
      smtp.send_mail body, from, to
    end
  end

end
