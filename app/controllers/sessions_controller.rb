class SessionsController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
      code = params[:code]

      if params[:action_type] == "create_new"
          # NEW USR: Create  a new 5-digit code
          if code.length != 5 || code !~ /\A\d{5}\z/
              flash[:alert] = "Kode harus 5 digit (0-9)"
              redirect_to root_path and return
          end

          if User.find_by_code(code)
              flash[:alert] = "Kode sudah ada, buat yang laen."
              redirect_to root_path and return
          end

          user = User.create!(code_hash: User.hash_code(code))
          session[:user_id] = user.id
          flash[:notice] = "Kode berhasil dibuat!"
          redirect_to dashboard_path

      elsif params[:action_type] == "access"
          # EXISTING USER: Verify code
          user = User.find_by_code(code)

          if user
              session[:user_id] = user.id
              session[:expire_at] = 1.hour.from_now
              redirect_to dashboard_path
          else
              flash[:alert] = "Kode salah, coba lagi"
              redirect_to root_path
          end
      end
  end

  def destroy
      session[:user_id] = nil
      redirect_to root_path
  end
end
