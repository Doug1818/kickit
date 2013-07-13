class SupportersController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :index, :edit, :update, :destroy]

  def new
    @supporter = Supporter.new
  end

  def create
    @supporter = current_user.supporters.build(params[:supporter])
    if @supporter.save
      flash[:success] = "Supporter added"
      redirect_to supporters_path
      SupporterMailer.supporter_welcome(@supporter).deliver
    else
      render 'new'
    end
  end

  def index
  	@supporters = current_user.supporters
    @supporter = Supporter.new
  end

  def edit
  	@supporter = Supporter.find(params[:id])
  end

  def update
  	@supporter = Supporter.find(params[:id])
    if @supporter.update_attributes(params[:supporter])
      flash[:success] = "Update successful"
      redirect_to supporters_path
    else
      render 'edit'
    end
  end

  def destroy
    @supporter = current_user.supporters.find(params[:id])
    @supporter.destroy
    flash[:notice] = "Supporter removed"
    redirect_to supporters_path
  end
end
