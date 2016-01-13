class StaticPagesController < ApplicationController

  skip_before_action :authenticate_user!

  def home
    load_members if current_user
    load_birthdays
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
        today = Date.today
        next_7_days = (Date.today + 1)...(Date.today + 7)
        next_30_days = (Date.today + 8)...(Date.today + 30)

        @today = members.where('extract(day from date_of_birth) = ? and extract(month from date_of_birth) = ?', today.day, today.month) 
        @next_7_days = members.where(date_of_birth: next_7_days)
        @next_30_days = members.where(date_of_birth: next_30_days)
      end
    end

    def user_members
      if params[:keywords].present?
        Member::Search.new(current_user.members, params[:keywords]).result
      end
    end
end
