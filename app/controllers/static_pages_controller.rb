class StaticPagesController < ApplicationController

	def home
		@user = User.new
		if user_signed_in?
			@days = current_user.days
	  		@today = params[:month] ? Date.parse(params[:month]) : Date.current
  		end
	end
end
