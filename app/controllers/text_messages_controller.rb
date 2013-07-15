class TextMessagesController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def receive
		sent_msg = params["Body"]
		from_number = params["From"][2..-1]
		@user = User.find_by_phone(from_number)
		@sent_text = @user.sent_texts.create(message: sent_msg)
		if Time.zone.now.hour >= 9 # Because check-in reminder comes in at 9am (13:00 UTC) on day + 1
			@day = @user.days.find_by_date(Date.current - 1)
		else
			@day = @user.days.find_by_date(Date.current - 2)
		end
		if !@day.nil? && Time.zone.now >= @day.date + 1 + 9.hours && Time.zone.now <= @day.date + 2 + 9.hours # User is in an active program (@day is not nil) and in the 24hr check-in window
			if sent_msg.upcase == "Y" || sent_msg.upcase == "N"
				if @day.result == 1 || @day.result == 2
					if Time.zone.now.hour >= 0 && Time.zone.now.hour < 9 # If it's between midnight and 9am
						received_msg = "You have already checked in for #{(Date.current - 1).strftime("%a, %b %d")}. To check in for #{Date.current.strftime("%a, %b %d")} go to http://www.kick-it-now.com or check in by text after 9am."
						response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
						render :xml => response.text
						received_text = @user.received_texts.create(message: received_msg)
					else
						received_msg = "You have already checked in today."
						response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
						render :xml => response.text
						received_text = @user.received_texts.create(message: received_msg)
					end
				elsif @day.result == 4
					if Time.zone.now.hour >= 0 && Time.zone.now.hour < 9 # If it's between midnight and 9am
						received_msg = "Check-in window for #{(Date.current - 1).strftime("%a, %b %d")} is closed. To check in for #{Date.current.strftime("%a, %b %d")} go to http://www.kick-it-now.com or check in by text after 9am."
						response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
						render :xml => response.text
						received_text = @user.received_texts.create(message: received_msg)
					else
						received_msg = "You have already checked in today."
						response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
						render :xml => response.text
						received_text = @user.received_texts.create(message: received_msg)
					end
				elsif @day.result == 3
					if sent_msg.upcase == "Y"
						@day.update_attributes(result: 1)
					elsif sent_msg.upcase == "N"
						@day.update_attributes(result: 2)
					end
					received_msg = "Thanks for checking in today!"
					response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
					render :xml => response.text
					received_text = @user.received_texts.create(message: received_msg)
				end
			else
				received_msg = "Invalid check-in. Please enter either 'Y' or 'N'. Thank you!"
				response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
				render :xml => response.text
				received_text = @user.received_texts.create(message: received_msg)
			end
		else
			if @user.start_date > Date.current
				received_msg = "Your Kick-It program hasn't started yet."
				response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
				render :xml => response.text
				received_text = @user.received_texts.create(message: received_msg)
			elsif @user.start_date == Date.current
				received_msg = "Your first check-in will be tomorrow morning."
				response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
				render :xml => response.text
				received_text = @user.received_texts.create(message: received_msg)
			else
				received_msg = "You are not signed up for a Kick-It program.  To start a new program go to http://www.kick-it-now.com"
				response = Twilio::TwiML::Response.new { |r| r.Sms received_msg }
				render :xml => response.text
				received_text = @user.received_texts.create(message: received_msg)
			end
		end
	end
end
