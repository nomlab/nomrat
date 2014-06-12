# -*- coding: utf-8 -*-

## Created: 2011-06-09 Y.Kimura

require 'oauth'

class TweetSender
  def initialize
    @consumer_key, @consumer_secret, @access_token, @access_token_secret =
      open( "_twitter_auth.stg" ).read.split("\n")

    @consumer = OAuth::Consumer.new(
      @consumer_key,
      @consumer_secret,
      :site => 'https://api.twitter.com'
    )

    @twitter = OAuth::AccessToken.new(
      @consumer,
      @access_token,
      @access_token_secret
    )
  end

  def send_message(string)
    @twitter.post("/1.1/statuses/update.json", {'status' => string})
  end
end
