nomnichi_bot
============

nomnichi is blog of nomura-laboratory's students.
nomnichi_bot tweets next nomnichi author.
To use this application, you needs these files:
(1) "_twitter_auth.stg"
(2) "_redmine_mail.stg"
(3) "NomTable.rb"

if you want to obtain these files and you are nomura-laboratory's member,
please send message to "kimura-y@swlab.cs.okayama-u.ac.jp".

* nomnichi( http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi )


METHOD1. inform nomnichi author
METHOD2. inform kinro title
METHOD3. inform GN KAIHATSU meeting

=========================================================================
            (html)   
+-----------+    +-----------------+
|nomlab-blog| -> |NomnichiGetter.rb| ----+
+-----------+    +-----------------+     |
                   L[ NomTable.rb ]      |
                                         |
+-----------+    +-----------------+     |
|Kinro-page | -> | KinroGetter.rb  | ----+
+-----------+    +-----------------+     |
                                         |
+-----------+    +-----------------+     |
|  Redmine  | -> |RedmineGetter.rb | ----+
+-----------+    +-----------------+     |
                                         V
                                    +------------+
                                    | nom_bot.rb | - - - Cron
                                    +------------+
          (API,SMTP)                     |
+-----------+    +-----------------+     |
|  Twitter  | <- | TweetSender.rb  | ----+
+-----------+    +-----------------+     |
                   L[ _twitter_auth.stg ]|
                                         |
+-----------+    +-----------------+     |
|  MEMBERs  | <- |  MailSender.rb  | ----+
+-----------+    +-----------------+
                   L[ _redmine_mail.stg ]
