class StaticPagesController < ApplicationController

	def home
		@lead = Lead.new
		@user = User.new
		if user_signed_in? && current_user.program != nil
			@days = current_user.program.days
	  		@today = params[:month] ? Date.parse(params[:month]) : Date.current
  		end
	end

	def carousel
		@user = User.new
	end
end
