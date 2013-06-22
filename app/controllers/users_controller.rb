class UsersController < ApplicationController
before_filter :authenticate_user!, only: [:setup, :do_setup]

	def setup
		@user = current_user
		t = Time.current
		@morning_rem = @user.reminders.new(name: "morning", time: DateTime.new(t.year,t.month,t.day,10,0,0,'-4'))
		@afternoon_rem = @user.reminders.new(name: "afternoon", time: DateTime.new(t.year,t.month,t.day,13,0,0,'-4'))
		@evening_rem = @user.reminders.new(name: "evening", time: DateTime.new(t.year,t.month,t.day,21,0,0,'-4'))
	end

	def do_setup
	    @user = current_user
	    #if params[:user][:start_date] != nil && !@user.start_date.is_a?(Date)
	    #  @user.start_date = Date.strptime(params[:user][:start_date],"%m/%d/%Y").to_date
	    #end
	    if @user.update_attributes(params[:user])
	      30.times { |i| @user.days.create(day: i + 1, date: @user.start_date + i) } if @user.start_date?
	      @user.update_attributes(end_date: @user.start_date + 30)
	      flash[:success] = "Set up complete!"
	      redirect_to root_path
	    else
	      flash[:error] = "Set up unsuccessful. Please make sure all fields are filled out correctly."
	      redirect_to root_path
	    end
	end
end