class TextMessagesController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def receive
		message = params["Body"]
		from_number = params["From"][2..-1]
		@user = User.find_by_phone(from_number)
		@day = @user.days.find_by_date(Date.today)
		@sent_text = @user.sent_texts.create(message: message)
		if !@day.nil? #User is in an active program (@day is not nil)
			if message.upcase == "Y" || message.upcase == "N"
				if @day.result?
					response = Twilio::TwiML::Response.new { |r| r.Sms "You have already checked in." }
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
				response = Twilio::TwiML::Response.new { |r| r.Sms "Invalid reply. Please enter either 'Y' or 'N'. Thank you!" }
				render :xml => response.text
			end
		else
			response = Twilio::TwiML::Response.new { |r| r.Sms "You are not signed up for a Kick it program.  To start a new program go to http://www.kick-it-now.com" }
			render :xml => response.text
		end
	end
end
