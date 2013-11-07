# -*- coding: utf-8 -*-
## Created  : 2013/10/07 -T.Okada
## Modified : 2013/10/07 -T.Okada
## Ruby Ver : 1.8.7
#####################
require 'rubygems'
require 'open-uri'
require 'json'
$KCODE = "UTF8"
#####################

class WeatherGetter
  def initialize
  end

  def get_weather
    open("http://weather.livedoor.com/forecast/webservice/json/v1?city=330010"){|io|
      weathers = JSON.parse(io.read)
      return weathers['forecasts'].shift['telop']
    }
  end

  def notice_weather(weather)
    if (/雨/ =~ weather) != nil
      return "今日のお天気は" + weather + "です! 傘を忘れずに持ってきましょう!"
    else
      return "今日のお天気は" + weather + "です!"
    end
  end
end
