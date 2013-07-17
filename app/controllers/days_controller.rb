class DaysController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  def index
  	@days = current_user.program.days
  	@today = params[:month] ? Date.parse(params[:month]) : Date.current
  end

  def show
  	@day = Day.find(params[:id])
  end

  def success
  	@day = Day.find(params[:id])
  	@day.update_attributes(result: 1)
  	redirect_to root_path
  end

  def failure
  	@day = Day.find(params[:id])
  	@day.update_attributes(result: 2)
  	redirect_to root_path
  end
end
