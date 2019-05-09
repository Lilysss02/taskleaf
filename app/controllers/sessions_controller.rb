class SessionsController < ApplicationController
  # ログインしていなくとも利用できる
  skip_before_action :login_required

  def new
  end

  def create
  	# 送られてきたメールアドレスでユーザーを検索
  	user = User.find_by(email: session_params[:email])

  	# ユーザーが見つかった場合、送られてきたパスワードによる認証をauthenticateメソッドを使って実行
  	if user&.authenticate(session_params[:password])
  		session[:user_id] = user.id
  		redirect_to root_path, notice: 'ログインしました。'
  	else
  		render :new
  	end
  end

  def destroy
  	reset_session
  	redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
  	params.require(:session).permit(:email, :password)
  end
end
