# -*- coding: utf-8 -*-
module NomnichiBot
  module Reporter
    class Tvshow

      def report
        # return nil unless program = NomnichiBot::Scrap.kinro.today
        return nil unless program = NomnichiBot::Scrap.kinro.today
        return "本日(#{program.date})の金曜ロードショーは" +
          "「#{program.title}」です．皆様早く帰りましょう．"
      end

    end # class Tvshow
  end # module Reporter
end # module NomnichiBot
