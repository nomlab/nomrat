# -*- coding: utf-8 -*-

## Created: 2011-06-09
## Authors: Y.Kimura, Yoshinari Nomura

require 'oauth'

module NomnichiBot
  class TweetSender
    def initialize
      config = Config.load(:twitter)

      consumer = OAuth::Consumer.new(
        config["consumer_key"],
        config["consumer_secret"],
        :site => 'https://api.twitter.com'
      )

      @twitter = OAuth::AccessToken.new(
        consumer,
        config["access_token"],
        config["access_token_secret"]
      )
    end

    def send_message(string)
      result = @twitter.post("/1.1/statuses/update.json", {'status' => string})
      puts result.body if $NOMNICHI_BOT_DEBUG
      return result
    end
  end # class TweetSender
end # module NomnichiBot
