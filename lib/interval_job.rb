module IntervalModule

class IntervalJob
	def perform
		User.active_program.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		 
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => "Reminder test"
			)
		end
	end
end

end