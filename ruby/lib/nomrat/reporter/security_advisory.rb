# -*- coding: utf-8 -*-
module Nomrat
  module Reporter
    class SecurityAdvisory

      def report
        return nil unless dsa = Scrap.open(:debian_security_advisory).yesterday
        return "Debian Security Advisory (#{dsa.date}): #{dsa.title} #{dsa.link}"
      end

    end # class SecurityAdvisory
  end # module Reporter
end # module Nomrat
