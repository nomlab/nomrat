# -*- coding: utf-8 -*-

## Created: 2012-10-31 Y.Kimura
## Author: Y.Kimura

require 'nkf'
require 'net/smtp'

class MailSender

  def send(body, setting_path, host = "localhost", port = 25, itr = "")
    ## [To,From,Subject] in this file
    ## separated by "\n"
    f = open( setting_path ).read
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
