module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
    #ユーザがログインしていれば true を返し、ログインしていなければ false を返す。
  end
end
