desc "Tasks to be performed on-the-hour"
task :full_hour_jobs => :environment do
	# REMINDERS_FULL: Send reminders with on-the-hour times
	User.active_program.all.each do |user|
		number_to_send_to = user.phone
		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

		messages = []
		user.remessages.each { |m| messages.push(m.content) }
		message = messages.empty? ? "Future you is thanking present you." : messages.sample

		user.reminders.each do |reminder|
			if Time.zone.now.hour == reminder.time.hour && reminder.time.min == 0
				@twilio_client.account.sms.messages.create(
					:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
					:to => number_to_send_to,
					:body => message
				)
				received_text = user.received_texts.create(message: message)
			end
		end
	end

	# TRACKING: Send daily tracking checkin text at 9am local time
	User.active_checkins.all.each do |user|
		if Time.now.in_time_zone(user.time_zone).hour == 9
			number_to_send_to = user.phone
			std_msg = "This is your daily Kick it check in. Were you successful yesterday? Reply 'Y' or 'N' to check in."
			message = user.checkin_msg? ? user.checkin_msg : std_msg
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		 
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => message
			)
			received_text = user.received_texts.create(message: message)
		end
	end

	# OPEN_WINDOW: Open check-in window at midnight local
	User.active_checkins.all.each do |user|
		if Time.now.in_time_zone(user.time_zone).hour == 0
			@day = user.days.find_by_date(Date.current - 1)
			@day.update_attributes(result: 3)
		end
	end

	# CLOSE_WINDOW: Close check-in window at 9am local
	User.active_checkins.all.each do |user|
		if Time.now.in_time_zone(user.time_zone).hour == 9
			@day = user.days.find_by_date(Date.current - 2)
			if @day.result == 3
				@day.update_attributes(result: 4)
				# And charge user $1
			end
		end
	end
end

desc "Tasks to be performed on the half-hour"
task :half_hour_jobs => :environment do
	# REMINDERS_FULL: Send reminders with half hour times
	User.active_program.all.each do |user|
		number_to_send_to = user.phone
		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

		messages = []
		user.remessages.each { |m| messages.push(m.content) }
		message = messages.empty? ? "Future you is thanking present you." : messages.sample

		user.reminders.each do |reminder|
			if Time.zone.now.hour == reminder.time.hour && reminder.time.min == 30
				@twilio_client.account.sms.messages.create(
					:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
					:to => number_to_send_to,
					:body => message
				)
				received_text = user.received_texts.create(message: message)
			end
		end
	end
end

desc "Send weekly supporter email"
task :weekly_supemail => :environment do
	User.all.each do |user|
		if user.start_date? && user.start_date < Date.current && ((Date.current - user.start_date).to_f/7).prettify.is_a?(Integer)
			UserMailer.supporter_update(user).deliver
		end
	end
end