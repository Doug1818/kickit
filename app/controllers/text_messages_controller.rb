class TextMessagesController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def receive
		message = params["Body"]
		from_number = params["From"][2..-1]
		@user = User.find_by_phone(from_number)
		@sent_text = @user.sent_texts.create(message: message)
		if Time.now.hour >= 9 #Because check-in reminder comes in at 9am on day + 1
			@day = @user.days.find_by_date(Date.today - 1)
		else
			@day = @user.days.find_by_date(Date.today - 2)
		end
		if !@day.nil? && Time.now >= @day + 1 + 9.hours && Time.now <= @day + 2 + 9.hours #User is in an active program (@day is not nil) and in the 24hr check-in window
			if message.upcase == "Y" || message.upcase == "N"
				if @day.result?
					response = Twilio::TwiML::Response.new { |r| r.Sms "You have already checked in today." }
					render :xml => response.text
				else
					if message.upcase == "Y"
						@day.update_attributes(result: 1)
					elsif message.upcase == "N"
						@day.update_attributes(result: 2)
					end
					response = Twilio::TwiML::Response.new { |r| r.Sms "Thanks for checking in today!" }
					render :xml => response.text
				end
			else
				response = Twilio::TwiML::Response.new { |r| r.Sms "Invalid check-in. Please enter either 'Y' or 'N'. Thank you!" }
				render :xml => response.text
			end
		else
			if @user.start_date > Date.today
				response = Twilio::TwiML::Response.new { |r| r.Sms "Your Kick it program hasn't started yet." }
				render :xml => response.text
			elsif @user.start_date == Date.today
				response = Twilio::TwiML::Response.new { |r| r.Sms "Your first check-in will be tomorrow morning." }
				render :xml => response.text
			else
				response = Twilio::TwiML::Response.new { |r| r.Sms "You are not signed up for a Kick it program.  To start a new program go to http://www.kick-it-now.com" }
				render :xml => response.text
			end
		end
	end
end
