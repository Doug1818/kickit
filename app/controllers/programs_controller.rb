class ProgramsController < ApplicationController
	before_filter :authenticate_user!, only: [:extend, :extend_program]
	layout :web_layout, only: [:extend_program]

	def extend
		@program = Program.find(params[:id])
		@user = User.find(@program.user_id)
		@old_end_date = @program.end_date
		@old_end_day_num = @program.days.find_by_date(@old_end_date).day
		@old_end_week_num = @program.weeks.find_by_end_date(@old_end_date).week
		days_num = 21
    weeks_num = days_num/7
		days_num.times { |i| @program.days.create(day: @old_end_day_num + i + 1, date: @old_end_date + i + 1, goal: "[Temporary Goal -- To Be Updated]") }
    weeks_num.times { |i| @program.weeks.create(week: @old_end_week_num + i + 1, start_date: @old_end_date + 1 + i*7, end_date: @old_end_date + 1 + 6 + i*7 ) }
    @program.update_attributes(end_date: @old_end_date += days_num)
    flash[:success] = "Program successfully extended"
    redirect_to user_path(@user)
	end

	def extend_program
	end

	private
    def web_layout
      if params[:format] != "mobile"
        "user_web"
      else
        "application"
      end
    end
end
