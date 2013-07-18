class SupmessagesController < ApplicationController
	def create
		@supporter = Supporter.find(params[:supmessage][:supporter_id])
		@supmessage = @supporter.supmessages.build(content: params[:supmessage][:content])
    if @supmessage.save
      flash[:success] = "Badge sent"
      redirect_to supporter_path(@supporter)
      UserMailer.supporter_badge(@supmessage).deliver
    else
      render 'supporters/show'
    end
	end
end
