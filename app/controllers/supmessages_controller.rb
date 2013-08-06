class SupmessagesController < ApplicationController
	def create
		@supporter = Supporter.find(params[:supmessage][:supporter_id])
		@supmessage = @supporter.supmessages.build(content: params[:supmessage][:content])
    @token = generate_token(@supporter)
    if @supmessage.save
      flash[:success] = "Message sent"
      redirect_to supporter_path(@token)
      UserMailer.supporter_badge(@supmessage).deliver
    else
      render 'supporters/show'
    end
	end

  def generate_token(supporter)
    Base64.encode64("#{supporter.id}X#{supporter.first_name}#{supporter.relationship}").gsub(/[^0-9a-z]/i, "")
  end
end
