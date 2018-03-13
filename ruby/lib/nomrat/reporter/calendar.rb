# -*- coding: utf-8 -*-
module Nomrat
  module Reporter
    class Calendar

      def report
        events = Scrap.open(:calendar)
        regexp   = /(打ち?合|談話|ミーティング)/
        message  = ""

        events.each do |event|
          next unless regexp =~ event.summary
          if (diff = (event.date - Date.today).to_i) <= 3 and diff > 0
            message << "#{event.summary}の#{diff}日前です．"
          end
        end
        message << "進捗どうですか?" unless message == ""
        return message.chomp unless message == ""
        return nil
      end

    end # class Calendar
  end # module Reporter
end # module Nomrat
