require "net/https"
require "uri"
require "json"

module NomnichiBot
  class SlackSender
    def initialize
      config = Config.load(:slack)

      @team     = config["team"]
      @token    = config["token"]
      @channel  = config["channel"]
      @username = config["username"]
      @post_uri = "https://#{@team}.slack.com/services/hooks/incoming-webhook?token=#{@token}"
    end

    def send_message(string, channel = @channel)
      uri = URI.parse(@post_uri)
      res = nil
      json = {channel: @channel, username: @username, text: string}.to_json
      request = "payload=" + json

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = http.post(uri.request_uri, request)
      end

      puts res.body if $NOMNICHI_BOT_DEBUG
      return res
    end
  end # class SlackSender
end # module NomnichiBot
