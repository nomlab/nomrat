# -*- coding: utf-8 -*-
## Create   : 2011/06/09 -Y.Kimura
## Modified : 2013/04/10 -Y.kimura
## Ruby Ver : 1.8.7
## Get&Return _kinro_
#####################
require 'rubygems'
require 'open-uri'
require 'kconv'
require 'time'
require 'date'
#####################

class KinroGetter
  def initialize
  end

  def get_kinro
  ##----------------------------------------------------------------------
  ## 金曜ロードショー
  ##----------------------------------------------------------------------

    ### Get kinro page
    sours = ""
    kinro_error = ""
    broad_fri = Time.now.strftime("%Y%m%d")
    url = "http://www.ntv.co.jp/kinro/lineup/#{broad_fri}/index.html"

    begin
      open( url ) {|f|
        f.each_line do |line|
          sours = line
          break if( line =~ /<h1 class="text-off-screen">/ )
        end
      }
    rescue
      kinro_error << "Error: fail to Get kinro page."
    end

    ### Make kinro speach message
    speach = ""
    begin
      sours =~ ( />([^<]*)</ )
      kinro = $1.toutf8
      speach = "本日は金曜日です．金曜ロードショーは「#{kinro}」です．皆様早く帰りましょう．" unless kinro == nil
    rescue
      kinro_error << "Error: fail to Make kinro speach message"
    end

    ### return or error
    if( kinro_error == "" )
      return speach
    else
      open("errorlog.txt", "w+"){|f|
        f.write kinro_error
      }
      return ""
    end

  end # method( get_kinro ) end

end # class end
