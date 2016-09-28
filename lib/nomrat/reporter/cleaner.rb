module Nomrat
  module Reporter
    class Cleaner
      CLEAN_WDAY = 1 # Monday

      def report
        return nil unless Date.today.wday == CLEAN_WDAY
        before_cleaner = Nomrat::Scrap.open(:cleaner).last.cleaner
        return "今週の掃除当番は #{next_cleaner(before_cleaner)} です．掃除後に報告をお願いします．"
      end

      private

      def cleaners
        return %w(
           okada kitagaki masuda-y
           ikeda-y ichikawa kobayashi nakamura fujita
           emi suetake sugi date yoshida-h
        )
      end

      def next_cleaner(before_cleaner)
        cleaners[cleaners.index(before_cleaner) + 1]
      end
    end # class Cleaner
  end # module Reporter
end # module Nomrat
