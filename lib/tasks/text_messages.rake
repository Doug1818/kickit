namespace :text do
	desc "Send text message"
	task :send => :environment do
		User.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		 
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => "This is your daily Kick it check in. Were you successful today? Reply 'Y' or 'N' to check in."
			)
		end
	end
end