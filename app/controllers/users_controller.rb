class UsersController < ApplicationController

  def print
    load_user
    respond_to do |format|
      format.pdf do
        send_data @user.to_pdf(params[:template]),
          content_type: Mime::PDF
      end
    end
  end

  private

    def load_user
      @user ||= current_user
    end

end
