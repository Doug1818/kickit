class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def send_text_message
	number_to_send_to = "9175879211"
 
	@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
 
	@twilio_client.account.sms.messages.create(
		:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
		:to => number_to_send_to,
		:body => "This is a message. It gets sent to #{number_to_send_to}"
	)
  end

  def receive_text_message
	message_body = params["Body"]
	from_number = params["From"]
	
	#SMSLogger.log_text_message from_number, message_body

	response = Twilio::TwiML::Response.new do |r|
		r.Sms "Daily check in complete!"
	end
	response.text
	render :nothing => true
	#binding.pry
  end
end
