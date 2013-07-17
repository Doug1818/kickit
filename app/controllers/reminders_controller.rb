class RemindersController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create, :index, :edit, :update, :destroy]

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = current_user.program.reminders.build(params[:reminder])
    if @reminder.save
      flash[:success] = "Reminder added"
      redirect_to reminders_path
    else
      render 'new'
    end
  end

  def index
  	@reminders = current_user.program.reminders
    @remessages = current_user.program.remessages
  end

  def edit
  	@reminder = Reminder.find(params[:id])
  end

  def update
  	@reminder = Reminder.find(params[:id])
    if @reminder.update_attributes(params[:reminder])
      flash[:success] = "Update successful"
      redirect_to reminders_path
    else
      render 'edit'
    end
  end

  def destroy
    @reminder = current_user.program.reminders.find(params[:id])
    @reminder.destroy
    flash[:notice] = "Reminder time deleted"
    redirect_to reminders_path
  end
end
