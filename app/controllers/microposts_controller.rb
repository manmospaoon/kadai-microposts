class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  #ログインが必須になる。
  before_action :correct_user, only: [:destroy]
  #destroy アクションが実行される前に correct_user が実行される。
  #correct_user メソッドでは、削除しようとしている Micropost が本当にログインユーザが所有しているものかを確認する。
  
  def create
     @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    #correct_userメソッドで取得した@micropost
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    #ログインユーザ (current_user) が持つ microposts 限定で検索。
    unless @micropost
    redirect_to root_url
    end
  end
end
