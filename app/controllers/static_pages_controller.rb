class StaticPagesController < ApplicationController

  skip_before_action :authenticate_user!

  def home
    load_members if current_user
  end

  def help
  end

  def about
  end

  private

    def load_members
      @members ||= user_members
    end

    def user_members
      if params[:keywords].present?
        Member::Search.new(current_user.members, params[:keywords]).result
      end
    end
end
