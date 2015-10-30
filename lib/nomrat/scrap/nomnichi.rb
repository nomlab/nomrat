require "mechanize"

module Nomrat
  module Scrap
    class Nomnichi < Base
      PAGE_URL = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/nomnichi"

      class Article
        attr_reader :date, :author

        def initialize(date, author)
          @date, @author = date, author
          @date = Date.parse(date) if date.is_a?(String)
        end
      end # class Article

      private

      def create_articles(content)
        articles, user, time = [], nil, nil

        content.scan(/icon-(user|time).*?<\/span>\s*([^\s<]+)/) do |key, val|
          user = val if key == "user"
          time = val if key == "time"
          if user && time
            articles << Article.new(time, user)
            user, time = nil, nil
          end
        end
        return articles
      end

      def fetch_content(config)
        login(config)
        content = ""

        for page in 1..5 do
          content +=
            begin
              @agent.get(PAGE_URL + "?page=#{page}").body
            rescue Mechanize::ResponseCodeError => e
              STDERR.print "(url: #{e.page.uri}.\n"
              return ""
            end
        end
        return content
      end

      def login(config)
        @agent = ::Mechanize.new
        @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @agent.follow_meta_refresh = true
        @agent.ssl_version = :SSLv3

        login_page = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/gate/login"
        # It works for me though...
        #   form = @agent.get(login_page).form
        #
        # Below is a paranoid way:
        #   Page#form_with does not take css or xpath.
        #   http://stackoverflow.com/questions/9142831/how-can-i-get-mechanize-objects-from-mechanizepages-search-method
        #
        page = @agent.get(login_page)
        form = page.search('form').first
        form = Mechanize::Form.new(form, @agent, page)
        form.field_with("ident").value = config["username"]
        form.field_with("password").value = config["password"]
        form.submit
        return self
      end
    end # class Nomnichi
  end # module Scrap
end # module Nomrat
