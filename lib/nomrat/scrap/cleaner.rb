require "json"

module Nomrat
  module Scrap
    class Cleaner < Base
      class Article
        attr_reader :date, :cleaner

        def initialize(date, cleaner)
          @date, @cleaner = date, cleaner
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      def initialize(config = nil)
        @token   = config["token"]
        @channel = config["channel"]
        @members = create_members

        @articles = create_articles(fetch_content(config))
      end

      private

      def create_articles(content)
        messages = JSON.parse(content)["messages"]
        cleaner_messages = messages.select{|m| m["text"] =~ /掃除を完了しました/}
        articles = cleaner_messages.map do |m|
          time = Time.at(m["ts"].to_i)
          date = Date.new(time.year, time.month, time.day)
          cleaner = @members[m["user"]]
          Article.new(date, cleaner)
        end
        return articles
      end

      def page_url
        "https://slack.com/api/channels.history?token=#{@token}&channel=#{channel_id}"
      end

      def create_members
        members_info = JSON.parse(open("https://slack.com/api/users.list?token=#{@token}").read)["members"]
        h = Hash.new
        members_info.each do |m|
          h[m["id"]] = m["name"]
        end
        h
      end

      def channel_id
        channels_info = JSON.parse(open("https://slack.com/api/channels.list?token=#{@token}").read)["channels"]
        channel_info = channels_info.select{|c| c["name"] == @channel}.first["id"]
      end
    end # class Cleaner
  end # module Scrap
end # module Nomrat
