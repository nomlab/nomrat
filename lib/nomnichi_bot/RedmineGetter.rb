# -*- coding: utf-8 -*-
## Created  : 2011/10/31 -Y.Kimura
## Modified : 2013/04/11 -Y.Kimura
## Ruby Ver : 1.8.7
## Get&Return next Itr and message for tweet or mail
#####################
require 'rubygems'
require 'open-uri'
require 'time'
require 'date'
#####################

class RedmineGetter

  def initialize
    @new_itr = ""
    @itr_date = Date.today
    @sours = ""
    @itr_page_address = ""
  end

  def new_itr
    @new_itr
  end

  def itr_date
    @itr_date
  end

##----------------------------------------------------------------------
## set the recent Itr page
##----------------------------------------------------------------------
  def get_itr
    ### GET next_itr
    error_message = ""
    redmine_page = "http://redmine.swlab.cs.okayama-u.ac.jp/projects/lastnote"
    
    begin
      open( redmine_page ){|f|
        f.each_line{|line|
          @sours += line
        }
      }
    rescue
      error_message << "Error: fail to Get redmine/lastnote page.\n"
    end
    
    ### GET newItr from redmine
    
    itrs = @sours.scan( /class=\"wiki\-page\">最新イテレーション\s\((Itr[\d]*)\)/ )
    @new_itr = itrs.first.to_s

    if( itrs != [])
      @itr_page_address = redmine_page + "/wiki/" + @new_itr
    else
      error_message << "Error: fail to Make itr_address.\n"
    end
    
    ### SET sours
    @sours = ""
    begin
      open( @itr_page_address ){|f|
        f.each_line{|line|
          @sours += line
        }
      }
    rescue
      error_message << "Error: fail to GET redmine/next_meeting.\n"
    end

    ##----------------------------------------------------------------------
    ## set next meeting date and author
    ##----------------------------------------------------------------------
    itr_note = ""
    date_next = nil
    date_before = nil
    writer = nil
    
    @sours.each {|line|
      itr_note = line 
      break if(line =~ /期間/)
    }
    
    begin
      if(itr_note =~ /期間[:|：][\s]*([\d]+\-[\d]+\-[\d]+)[^\d]*([\d]+\-[\d]+\-[\d]+)/)
        date_before = $1
        date_next = $2
      end
      
      if(itr_note =~ /書記[:|：][\s]*([^<]*)/)
        writer = $1
      end
    rescue
      error_message << "Error: fail to set next meeting date.\n"
    end
    
    date_arr = date_next.split("-")
    @itr_date = Date.new( date_arr[0].to_i, date_arr[1].to_i, date_arr[2].to_i )
    
    ##----------------------------------------------------------------------
    ## set tweet speach
    ##----------------------------------------------------------------------
    speach = ""
    
    if(@itr_date - Date.today == 3)
      speach = "GN開発打合せ3日前です．書記の#{writer}さんは今イテレーションのwikiのページを確認してください．->(#{@itr_page_address})"
    end
    if(@itr_date - Date.today == 2)
      speach = "GN開発打合せ2日前です．GNグループの皆様は各自チケットの更新を確認してください．"
    end
    
    ### output error message
    if( error_message == "" )
      return speach
    else
      errors = Time.now.strftime("%Y/%m/%d : ") + "\n"
      open("errorlog.txt", "w+"){|f|
        errors << error_message
        f.write errors
      }
      return ""
    end
    
  end # method( get_itr ) end
  
  
###----------------------------------------------------------------------
### SEND MAIL
###----------------------------------------------------------------------
  def get_ticket
    mail_message = ""
    ### Set updated ticket
    if( /<p>\(更新あり\)(.*)<\/p>/ =~ @sours )
      string_non_updateds = $1.to_s
      non_updateds = Array.new
      non_updateds = string_non_updateds.scan( /br \/><a href=\"[^\"]*\" class=\"[^\"]*\" title="([^\"]*)\s\(([^\"]*)\)">#([\d]+)<\/a>([^<]*)</ )
      
      mail_message << "* 更新あり\n"
      non_updateds.each{|elem| # [ 0:Title, 1:status , 2:ticket_number, 3:strings]
        mail_message << "  + ##{elem[2]}   #{elem[0]}\n" # #ticketnum : Title
        
        user = " ".ljust(20)
        if( elem[3] =~ /([a-zA-Z]+\s[\a-zA-Z]+)$/ )
          user = $1.ljust(20)
        end
        
        mail_message << "    (#{elem[1]}) #{user} [[ http://redmine.swlab.cs.okayama-u.ac.jp/issues/#{elem[2]} ]]\n"
      }
    end
    
    ### Set non_updated ticket
    if( /<p>\(更新なし\)(.*)<\/p>/ =~ @sours )
      string_non_updateds = $1.to_s
      non_updateds = Array.new
      non_updateds = string_non_updateds.scan( /br \/><a href=\"[^\"]*\" class=\"[^\"]*\" title="([^\"]*)\s\(([^\"]*)\)">#([\d]+)<\/a>([^<]*)</ )

      mail_message << "* 更新なし\n"
      non_updateds.each{|elem| # [ 0:Title, 1:status , 2:ticket_number, 3:strings]
        mail_message << "  + ##{elem[2]}   #{elem[0]}\n" # #ticketnum : Title
        
        user = " ".ljust(20)
        if( elem[3] =~ /([a-zA-Z]+\s[\a-zA-Z]+)$/ )
          user = $1.ljust(20)
        end
        
        mail_message << "    (#{elem[1]}) #{user} [[ http://redmine.swlab.cs.okayama-u.ac.jp/issues/#{elem[2]} ]]\n"
      }
    end


    ### Send mail to GN member
    message = "GNグループの皆さまへ\n\n"
    message << "GN開発打合せ2日前です．\n今イテレーションのチケットは以下の通りです．\n\n"
    
    if(mail_message == "")
      message << "・・・チケットの記述の形式が異なります．\n"
    else
      message << "----------------------------------------------------------------------------------------\n"
      message << mail_message
      message << "----------------------------------------------------------------------------------------\n"
    end
    
    message << "\nなお，今イテレーションにおけるチケットに関しましては，以下をご参照ください．\n"
    message << @itr_page_address
    
    return message
    
  end # method( get_ticket ) end
  
end # class end
