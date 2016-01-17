class StaticPagesController < ApplicationController

  skip_before_action :authenticate_user!

  def home
    if current_user
      load_members
      load_birthdays
      load_events
    end
  end

  def help
  end

  def about
  end

  private

    def load_members
      @members ||= user_members
    end

    def load_birthdays
      members = current_user.members

      if members
        query = "date_is_in_range(date_of_birth, :start, :end)"
        today = Date.today
        today_range = { start: today, end: today }
        next_7_range = { start: today + 1, end: today + 7 }
        next_30_range = { start: today + 8, end: today + 30 }

        @today = members.where(query, today_range).by_date_of_birth 
        @next_7_days = members.where(query, next_7_range).by_date_of_birth
        @next_30_days = members.where(query, next_30_range).by_date_of_birth
      end
    end

    def load_events
      events = current_user.events

      if events
        query = "start_date between :start and :end"
        today = Date.today
        today_range = { start: today, end: today }
        next_7_range = { start: today + 1, end: today + 7 }
        next_30_range = { start: today + 8, end: today + 30 }

        @events_today = events.where(query, today_range).by_date
        @events_next_7_days = events.where(query, next_7_range).by_date
        @events_next_30_days = events.where(query, next_30_range).by_date
      end
    end
    def user_members
      if params[:keywords].present?
        Member::Search.new(current_user.members, params[:keywords]).result
      end
    end
end
