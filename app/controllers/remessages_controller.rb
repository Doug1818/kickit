class RemessagesController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @remessage = Remessage.new
  end

  def create
    @remessage = current_user.remessages.build(params[:remessage])
    if @remessage.save
      flash[:success] = "Reminder message added"
      redirect_to reminders_path
    else
      render 'new'
    end
  end

  def edit
  	@remessage = Remessage.find(params[:id])
  end

  def update
  	@remessage = Remessage.find(params[:id])
    if @remessage.update_attributes(params[:remessage])
      flash[:success] = "Update successful"
      redirect_to reminders_path
    else
      render 'edit'
    end
  end

  def destroy
    @remessage = current_user.remessages.find(params[:id])
    @remessage.destroy
    flash[:notice] = "Reminder message deleted"
    redirect_to reminders_path
  end
end
