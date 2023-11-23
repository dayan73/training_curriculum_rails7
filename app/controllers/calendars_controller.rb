 # １週間のカレンダーと予定が表示されるページ
class CalendarsController < ApplicationController
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    @calendar = Calendar.new(calendar_params)
    if @calendar.save
      redirect_to @calendar
    else
      render :new
    end
  end

  private
  def plan_params
    params.require(:calendars).permit(:date, :plan)
  end

def  getWeek
    # 曜日の配列
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']


    # 今日の日付
    @todays_date = Date.today

    # 週のデータを格納する配列
    @week_days = []

    # 今日から6日後までの予定を取得
    plans = Plan.where(date: @todays_date..(@todays_date + 6))

    # 7日分のデータを取得
    7.times do |x|
      # 各日の予定を格納する配列
      today_plans = []
      plans.each do |plan|
        # 予定の日付が、現在の日付+X(0から6までのループ)と一致する場合、予定を追加
        if plan.date == (@todays_date + x)
          today_plans.push(plan.plan)
        end
      end
      # リファクタリング前のコードでは、
    # 月、日、予定を連想配列として格納していたが、
    # 曜日の情報も追加するため、連想配列に wday キーを追加する
    days = {
      month: (@todays_date + x).month,
      date: (@todays_date + x).day,
      wday: wdays[(@todays_date + x).wday], # 曜日の情報
      plans: today_plans
    }
      @week_days.push(days)
    end
  end
end