class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Begin - SYC extenstions for Devise

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    organizations_path
  end

  # End - SYC extensions for Devise
  
end
