class DaysController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  def index
  	@days = current_user.days
  	@today = params[:month] ? Date.parse(params[:month]) : Date.today
  end

  def show
  	@day = Day.find(params[:id])
  end

  def success
  	#binding.pry
  	@day = Day.find(params[:id])
  	@day.update_attributes(result: 1)
  	redirect_to root_path
  end

  def failure
  	@day = Day.find(params[:id])
  	@day.update_attributes(result: 1)
  	redirect_to root_path
  end
end
