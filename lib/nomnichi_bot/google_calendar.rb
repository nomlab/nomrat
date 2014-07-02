require "google/api_client"
require 'google/api_client/auth/installed_app'

module NomnichiBot
  # See: https://developers.google.com/google-apps/calendar/v3/reference/?hl=ja
  class GoogleCalendar


    # https://developers.google.com/google-apps/calendar/v3/reference/events?hl=ja#resource
    class Event
      def initialize(api_data)
        @api_data = api_data
      end

      def summary
        @api_data.summary
      end

      def dtstart
        @api_data.start.date_time ||
          Date.parse(@api_data.start.date)
      end

      def dtend
        @api_data.end.date_time ||
          Date.parse(@api_data.end.date)
      end

      def dump
        @api_data
      end
    end

    # see
    # https://github.com/google/google-api-ruby-client#example-usage
    # http://stackoverflow.com/questions/12572723/rails-google-client-api-unable-to-exchange-a-refresh-token-for-access-token

    def initialize(config)
      @config = config
      @client = Google::APIClient.new(
        :application_name => "nomnichi_bot",
        :application_version => NomnichiBot::VERSION
      )

      @client.authorization.scope         = "https://www.googleapis.com/auth/calendar"
      @client.authorization.client_id     = @config["client_id"]
      @client.authorization.client_secret = @config["client_secret"]
      @client.authorization.access_token  = @config["access_token"]
      @client.authorization.refresh_token = @config["refresh_token"]

      begin
        @client.authorization.grant_type = "refresh_token"
        @client.authorization.fetch_access_token!
      rescue ::Signet::AuthorizationError => e
        initialize_token(@config)
      end
      save_authorization_info

      @service = @client.discovered_api('calendar', 'v3')
    end

    def events(calendar_id)
      params, entries, page_token = {'calendarId' => calendar_id}, [], nil

      begin
        params['pageToken'] = page_token if page_token
        result = @client.execute(:api_method => @service.events.list,
                                 :parameters => params)

        entries += result.data.items.map{|e| Event.new(e)}
      end while (page_token = result.data.next_page_token)
      return entries
    end

    private

    def save_authorization_info
      @config["client_id"]     = @client.authorization.client_id
      @config["client_secret"] = @client.authorization.client_secret
      @config["access_token"]  = @client.authorization.access_token
      @config["refresh_token"] = @client.authorization.refresh_token
    end

    def initialize_token
      flow = Google::APIClient::InstalledAppFlow.new(
        :client_id => @config["client_id"],
        :client_secret => @config["client_secret"],
        :scope => ["https://www.googleapis.com/auth/calendar"]
      )
      @client.authorization = flow.authorize
    end

  end # class Calendar
end # module NomnichiBot
