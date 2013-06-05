class DaysController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  def index
  	@days = current_user.days
  	@today = params[:month] ? Date.parse(params[:month]) : Date.today
  end
end
