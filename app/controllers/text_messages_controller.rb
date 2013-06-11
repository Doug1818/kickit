class TextMessagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receive
	message_body = params["Body"]
	from_number = params["From"]
	
	#SMSLogger.log_text_message from_number, message_body

	response = Twilio::TwiML::Response.new do |r|
		r.Sms "Daily check in complete!"
	end
	render :xml => response.text
  end
end
