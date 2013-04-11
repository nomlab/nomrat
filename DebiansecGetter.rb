# -*- coding: utf-8 -*-
## Create   : 2013/04/10 -Y.Kimura
## Modified : 2013/04/11 -Y.kimura
## Ruby Ver : 1.8.7
## Get&Return _kinro_
#####################
require 'rubygems'
require 'open-uri'
require 'kconv'
require 'time'
require 'date'
$KCODE = "UTF8"
#####################

class DebiansecGetter
  def initialize
  end

  def get_sec
  ##----------------------------------------------------------------------
  ## Get Debian's security information
  ##----------------------------------------------------------------------

    ### Get kinro page
    sours = ""
    sec_error = ""
    year = Time.now.strftime("%Y")
    url = "http://www.debian.org/security/#{year}/index.ja.html"
    
    begin
      open( url ) {|f|
        f.each_line{|line|
          sours << line
        }
      }
    rescue
      sec_error << "Error: fail to Get kinro page."
    end
    
    latest_sec = ""
    begin
      latest_sec = open("latest_sec.txt", "r").gets
    rescue
      sec_error << "Error: read latest_sec"
    end
    
    informations = Array.new
    informations = sours.scan(/<tt>.*<br>/)
    
    todays_infos = Array.new
    write_back_date = latest_sec

    informations.each{|sec_info|
      if(sec_info =~ /<tt>\[(.*)\]<\/tt>/)
        date = $1
        if( Date.strptime( date ) > Date.strptime( latest_sec ) )
          sec_info =~ /DSA-([\d]+)\s+([^<]*).*\-\s([^<]*)/
          dsa_num = $1
          package = $2
          bug = $3
          todays_infos << "(#{date}報告) #{package}: #{bug} \n ->詳細(http://www.debian.org/security/2013/dsa-#{dsa_num}) \n"
        end

        write_back_date = date if( Date.strptime( date ) > Date.strptime( write_back_date ) )
      end
    }

    open( "latest_sec.txt", "w+" ){|f|
      f.write write_back_date
    }
    
    return todays_infos
    
  end # method( get_sec ) end
  
end # class end
