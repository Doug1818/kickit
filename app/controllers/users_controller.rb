class UsersController < ApplicationController
before_filter :authenticate_user!, only: [:setup, :do_setup, :billing, :add_billing_info]

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
    #number_to_send_to = params[:user][:phone]
    #message = "Welcome to Kick-It! We'll be using this number to send you reminders over the course of your program, so you should save it to your contacts as 'Kick-It'."
    #begin
    #  @twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    #  @twilio_client.account.sms.messages.create(
    #    :from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
    #    :to => number_to_send_to,
    #    :body => message
    #  )
    #rescue Twilio::REST::RequestError => e
    #  flash[:error] = e.message
    #end
    #if e == nil && @user.update_attributes(params[:user])
    if @user.update_attributes(params[:user])
			@program = @user.programs.last
			@received_text = @program.received_texts.create(message: message)
			@user.update_attributes(setup_flag: false)
      flash[:success] = "Set up complete!"
      redirect_to root_path
      #UserMailer.supporter_welcome(@user).deliver
    else
      @program = @user.programs.build
      t = Time.zone.now
      @morning_rem = @program.reminders.build(time: DateTime.new(t.year,t.month,t.day,10,0,0,'-4'))
      @afternoon_rem = @program.reminders.build(time: DateTime.new(t.year,t.month,t.day,13,0,0,'-4'))
      @evening_rem = @program.reminders.build(time: DateTime.new(t.year,t.month,t.day,21,0,0,'-4'))
      render 'setup'
    end
	end

  def billing
  end

  def add_billing_info
    current_user.stripe_card_token = params[:user][:stripe_card_token]
    if current_user.save_with_payment
      flash[:success] = "Billing info added successfully"
      redirect_to root_path
    else
      render "billing"
    end
  end
end