# -*- coding: utf-8 -*-
module NomnichiBot
  module Reporter
    class SecurityAdvisory

      def report
        return nil unless dsa = NomnichiBot::Scrap.debian_security_advisory.today
        return "Debian Security Advisory (#{dsa.date}): #{dsa.title} #{dsa.link}"
      end

    end # class SecurityAdvisory
  end # module Reporter
end # module NomnichiBot
