# -*- coding: utf-8 -*-
## Created  : 2011/06/09 -Y.Kimura
## Modified : 2012/12/11 -Y.Kimura
## Ruby Ver : 1.8.7
## tweet string
##################
require 'rubygems'
require 'oauth'
$KCODE = "UTF8"
##################

##---------------------------------------------------TweetClass:send tweet
class Tweet

  def initialize
    ## [ConsumerKey,Secret,AccessToken,Secret] in this file.
    ## separated by "\n"
    f = open( "TwitterAuthorize.txt" ).read
    tokens = f.split("\n")

    @consumer = OAuth::Consumer.new(
      @CONSUMER_KEY = tokens[0],
      @CONSUMER_SECRET = tokens[1],
      :site => 'https://api.twitter.com'
    )
    @access_token = OAuth::AccessToken.new(
      @consumer,
      @ACCESS_TOKEN = tokens[2],
      @ACCESS_TOKEN_SECRET =tokens[3]
    )
  end

  ## tweet
  def send_message( string )
    posted = @access_token.post(
               '/1.1/statuses/update.json',
               'status' => string
             )
    return posted
  end

end
