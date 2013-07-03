class SupmessagesController < ApplicationController

	def create
		@user = User.find(params[:supmessage][:user_id])
		@supmessage = @user.supmessages.build(content: params[:supmessage][:content])
    if @supmessage.save
      flash[:success] = "Badge sent"
      redirect_to user_path(@user)
      UserMailer.supporter_badge(@supmessage).deliver
    else
      render 'users/show'
    end
	end
end
