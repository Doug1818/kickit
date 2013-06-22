class RemindersController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :index, :edit, :update]

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = current_user.reminders.build(params[:reminder])
    if @reminder.save
      flash[:success] = "Reminder added"
      redirect_to reminders_path
    else
      render 'new'
    end
  end

  def index
  	@reminders = current_user.reminders
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
end
