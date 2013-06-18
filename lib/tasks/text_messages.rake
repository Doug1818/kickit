namespace :text do
	desc "Send text message"
	task :send => :environment do
		User.active_program.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		 
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => "This is your daily Kick it check in. Were you successful today? Reply 'Y' or 'N' to check in."
			)
		end
	end

	desc "Open check-in window"
	task :open_window => :environment do
		User.active_program.all.each do |user|
			@day = user.days.find_by_date(Date.today)
			@day.update_attributes(result: 3)
		end
	end

	desc "Close check-in window"
	task :close_window => :environment do
		User.active_program.all.each do |user|
			@day = user.days.find_by_date(Date.today) # To be changed to Date.today - 1
			@day.update_attributes(result: 4) if @day.result == 3
		end
	end
end