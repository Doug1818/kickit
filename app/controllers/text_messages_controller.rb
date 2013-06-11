class TextMessagesController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def receive
		message = params["Body"]
		from_number = params["From"][2..-1]
		@user = User.find_by_phone(from_number)
		@day = @user.days.find_by_date(Date.today)
		#binding.pry
		@sent_text = @user.sent_texts.create(message: message)
		if @user.start_date <= Date.today && @user.end_date >= Date.today
			if @sent_text.message.upcase == "Y" || @sent_text.message.upcase == "N"
				if @day.result?
					response = Twilio::TwiML::Response.new { |r| r.Sms "You have already checked in" }
					render :xml => response.text
				else
					response = Twilio::TwiML::Response.new { |r| r.Sms "Thanks for checking in today!" }
					render :xml => response.text
					@day.update_attributes(result: 1)
				end
			else
				response = Twilio::TwiML::Response.new { |r| r.Sms "Invalid reply. Please enter either 'Y' or 'N'. Thank you!" }
				render :xml => response.text
			end
		end
	end
end
