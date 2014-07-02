require "mechanize"

module NomnichiBot
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

      def login(config)
        @agent = ::Mechanize.new
        @agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @agent.follow_meta_refresh = true
        @agent.ssl_version = :SSLv3

        login_page = "http://www.swlab.cs.okayama-u.ac.jp/lab/nom/auth/login"
        # It works for me though...
        #   form = @agent.get(login_page).form
        #
        # Below is a paranoid way:
        #   Page#form_with does not take css or xpath.
        #   http://stackoverflow.com/questions/9142831/how-can-i-get-mechanize-objects-from-mechanizepages-search-method
        #
        page = @agent.get(login_page)
        form = page.search('div#login form').first
        form = Mechanize::Form.new(form, @agent, page)
        form.field_with("username").value = config["username"]
        form.field_with("password").value = config["password"]
        form.submit
        return self
      end

      def content(url)
        begin
          @agent.get(url).body
        rescue Mechanize::ResponseCodeError => e
          STDERR.print "(url: #{e.page.uri}.\n"
          return ""
        end
      end

      def create_articles(content)
        content.scan(/>(\d{4}-\d{2}-\d{2}) +([\da-z-]+)</).map do |date, author|
          Article.new(date, author)
        end
      end

    end # class Nomnichi
  end # module Scrap
end # module NomnichiBot
