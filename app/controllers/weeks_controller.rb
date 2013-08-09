class WeeksController < ApplicationController
  before_filter :authenticate_admin!, only: [:update]

  def update
  	@week = Week.find(params[:id])
  	if @week.update_week(params[:week])
      flash[:success] = "Update successful"
      redirect_to update_programs_path
    else
      flash[:error] = "Update not successful"
      redirect_to update_programs_path
    end
    #binding.pry
  end
end
