namespace :text do
	desc "Send text message"
	task :tracking => :environment do
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

	desc "Send reminders with on-the-hour times"
	task :reminders_full => :environment do
		User.active_program.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

			messages = []
			user.remessages.each { |m| messages.push(m.content) }

			user.reminders.each do |reminder|
				if Time.current.hour == reminder.time.hour && reminder.time.min == 0
					@twilio_client.account.sms.messages.create(
						:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
						:to => number_to_send_to,
						:body => messages.empty? ? "Future you is thanking present you." : messages.sample
					)
				end
			end
		end
	end

	desc "Send reminders with half hour times"
	task :reminders_half => :environment do
		User.active_program.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

			messages = []
			user.remessages.each { |m| messages.push(m.content) }

			user.reminders.each do |reminder|
				if Time.current.hour == reminder.time.hour && reminder.time.min == 30
					@twilio_client.account.sms.messages.create(
						:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
						:to => number_to_send_to,
						:body => messages.empty? ? "Future you is thanking present you." : messages.sample
					)
				end
			end
		end
	end
end

namespace :checkin do
	desc "Open check-in window"
	task :open_window => :environment do
		User.active_program.all.each do |user|
			@day = user.days.find_by_date(Date.current - 1)
			@day.update_attributes(result: 3)
		end
	end

	desc "Close check-in window"
	task :close_window => :environment do
		User.active_program.all.each do |user|
			@day = user.days.find_by_date(Date.current - 2)
			if @day.result == 3
				@day.update_attributes(result: 4)
				# And charge user $1
			end
		end
	end
end