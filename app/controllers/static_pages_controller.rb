class StaticPagesController < ApplicationController

	def carousel
		@user = User.new
	end

	def home
		@lead = Lead.new
		@user = User.new
		if user_signed_in?
			if current_user.current_program != nil # If in an active program
	      redirect_to calendar_path
	    elsif current_user.program == nil # If signed up only
	    	redirect_to signedup_path
	  	elsif current_user.programs.count >= 1 && current_user.next_program.start_date > Date.current # If signed up / setup but not started
	  		redirect_to checklist_path
	  	end
  	end
	end

	def calendar
		if user_signed_in? && current_user.program != nil
			@days = current_user.program.days
  		@today = params[:month] ? Date.parse(params[:month]) : Date.current
  		@day = current_user.program.days.find_by_date(Date.current)
		end
	end

	def signedup
	end

	def checklist
	end

	def nbtricks
	end

	def estricks
	end

	def lnstricks
	end

	def oetricks
	end
end
