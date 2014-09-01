# -*- coding: utf-8 -*-
require 'yaml'
require File.dirname(__FILE__) + '/GCal'
require 'google/api_client'

### カレンダから情報を取ってくるクラス
class CalendarGetter
  def initialize
    @gcal = GCal.new('CalendarGetter')
    @google_calendar_ids = YAML.load_file(File.dirname(__FILE__) + '/settings.yaml')["google_calendar_ids"]
  end

  ### イベントのリストを取得
  def get_events
    events = []
    @google_calendar_ids.each do |google_calendar_id|
      events = @gcal.event_list(google_calendar_id)
    end
  end

  ### 指定した名前に一致するイベントのリストを取得
  def get_events_by_name(keywords)
    events = []
    @google_calendar_ids.each do |google_calendar_id|
      events = @gcal.event_list_find_by_name(google_calendar_id, keywords)
    end
    return events
  end
end

### 取得したカレンダ情報を元に．メッセージを作成
class CalendarMessenger
  def initialize
    @calendar_getter = CalendarGetter.new
  end

  ### 打合せのリマインダを作成
  def create_meeting_reminder
    date = 3
    today = Date.today
    message = ""

    keywords = ["打ち合わせ", "打合せ", "談話会","ミーティング"]
    events = @calendar_getter.get_events_by_name(keywords)
    events.each do |event|
      if event.start.date_time != nil
        if event.start.date_time.to_date == today #(today - date)
          summary = event.summary
          message += "#{summary}の#{date}日前です．準備できていますか?"
          message += "\n"
        end
      end
    end
    return message
  end
end
