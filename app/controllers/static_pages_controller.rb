class StaticPagesController < ApplicationController
	def home
		@user = User.new
		3.times { @user.reminders.new }
		if user_signed_in?
			@days = current_user.days
	  		@today = params[:month] ? Date.parse(params[:month]) : Date.today
  		end
	end
end
