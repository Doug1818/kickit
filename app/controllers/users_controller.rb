class UsersController < ApplicationController
  def send_text_message
    number_to_send_to = "9175879211"
 
    @twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
 
    @twilio_client.account.sms.messages.create(
      :from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
      :to => number_to_send_to,
      :body => "This is a message. It gets sent to #{number_to_send_to}"
    )
  end
end
