class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :show_banner

  def authenticate
    redirect_to :back unless current_user || controller_name == 'sessions'
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def show_banner
    count_views % 10 == 0
  end

  private

    def count_views
      if cookies[:views].present?
        cookies[:views] = cookies[:views].to_i + 1;
      else
        cookies[:views] = 1;
      end
    end
end

