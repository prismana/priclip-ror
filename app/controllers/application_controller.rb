class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  
    allow_browser versions: :modern
    
    before_action :require_login
    before_action :check_session_expiry
    
    private

    def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def require_login
        unless current_user
            redirect_to root_path, alert: "Please enter your code to access clips."
        end
    end

    def check_session_expiry
        if session[:expires_at] && session[:expires_at] < Time.current
            session[:user_id] = nil
            session[:expires_at] = nil
            redirect_to root_path, alert: "Sesi berakhir, silahkan masukkan kode lagi"
        end
    end
end
