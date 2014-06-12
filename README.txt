* nomnichi_bot

** What is nomnichi_bot?

  Nomnichi is a blog of nomura-laboratory's students.
  (http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi)

  nomnichi_bot tweets us who is expected to write
  a new nomnichi blog article as a reminder.

  To use this application, you needs these setup:
  1) Twitter credencial as _twitter_auth.stg
  2) Redmine credential as _redmine_mail.stg
  3) Member list of the labo as nom_table.rb

** Functions

   1) Remind next nomnichi author
   2) Inform kinro title
   3) Remind GN delopment meeting

** Structure

   #+BEGIN_EXAMPLE
     +-----------+    +-----------------+
     |nomlab-blog| -> |NomnichiGetter   | ----+
     +-----------+    +-----------------+     |
                        L[ NomTable    ]      |
                                              |
     +-----------+    +-----------------+     |
     |Kinro-page | -> | KinroGetter     | ----+
     +-----------+    +-----------------+     |
                                              |
     +-----------+    +-----------------+     |
     |  Redmine  | -> |RedmineGetter    | ----+
     +-----------+    +-----------------+     |
                                              V
                                         +--------------+
                                         | nomnichi_bot | - - - Cron
                                         +--------------+
               (API,SMTP)                     |
     +-----------+    +-----------------+     |
     |  Twitter  | <- | TweetSender     | ----+
     +-----------+    +-----------------+     |
                        L[ _twitter_auth.stg ]|
                                              |
     +-----------+    +-----------------+     |
     |  MEMBERs  | <- |  MailSender     | ----+
     +-----------+    +-----------------+
                        L[ _redmine_mail.stg ]
   #+END_EXAMPLE
