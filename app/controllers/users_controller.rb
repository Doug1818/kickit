class UsersController < ApplicationController
before_filter :authenticate_user!, only: [:setup, :do_setup]

	def setup
		@user = current_user
    @program = @user.programs.build
    t = Time.zone.now
    @morning_rem = @program.reminders.build(time: DateTime.new(t.year,t.month,t.day,10,0,0,'-4'))
    @afternoon_rem = @program.reminders.build(time: DateTime.new(t.year,t.month,t.day,13,0,0,'-4'))
    @evening_rem = @program.reminders.build(time: DateTime.new(t.year,t.month,t.day,21,0,0,'-4'))
	end

	def do_setup
    @user = current_user
    if @user.update_attributes(params[:user])
      number_to_send_to = @user.phone
      message = "Welcome to Kick-It! We'll be using this number to send you reminders over the course of your program, so you should save it to your contacts as 'Kick-It'."
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => message
			)
			@program = @user.programs.last
			@received_text = @program.received_texts.create(message: message)
			@user.update_attributes(setup_flag: false)
      flash[:success] = "Set up complete!"
      redirect_to root_path
      #UserMailer.supporter_welcome(@user).deliver
    else
      render 'setup'
    end
	end

	def show
		@user = User.find(params[:id])
		@supmessage = @user.supmessages.build
	end
end