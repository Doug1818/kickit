desc "Tasks to be performed on-the-hour"
task :full_hour_jobs => :environment do
	# REMINDERS_FULL: Send reminders with on-the-hour times
	Program.active_program.all.each do |program|
		user = User.find(program.user_id)
		number_to_send_to = user.phone
		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

		messages = []
		program.remessages.each { |m| messages.push(m.content) }
		message = messages.empty? ? "Future you is thanking present you." : messages.sample

		program.reminders.each do |reminder|
			if Time.zone.now.hour == reminder.time.hour && reminder.time.min == 0
				@twilio_client.account.sms.messages.create(
					:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
					:to => number_to_send_to,
					:body => message
				)
				received_text = program.received_texts.create(message: message)
			end
		end
	end

	# TRACKING: Send daily tracking checkin text at 9am local time
	Program.active_checkins.all.each do |program|
		user = User.find(program.user_id)
		if Time.now.in_time_zone(user.time_zone).hour == 9
			number_to_send_to = user.phone
			if program.free_days_left > 0
				std_msg = "[Kick-It] Were you successful yesterday? Reply 'Y' (Yes), 'N' (No), or 'F' (Free Day)."
				custom_msg = "[Kick-It] #{program.days.find_by_date(Date.current).checkin_msg} Reply 'Y' (Yes), 'N' (No), or 'F' (Free Day)."
			else
				std_msg = "[Kick-It] Were you successful yesterday? Reply 'Y' or 'N' to check in."
				custom_msg = "[Kick-It] #{program.days.find_by_date(Date.current).checkin_msg} Reply 'Y' or 'N' to check in."
			end
			message = program.days.find_by_date(Date.current).checkin_msg != nil ? custom_msg : std_msg
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		 
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => message
			)
			received_text = program.received_texts.create(message: message)
		end
	end

	# OPEN_WINDOW: Open check-in window at midnight local
	Program.active_checkins.all.each do |program|
		user = User.find(program.user_id)
		if Time.now.in_time_zone(user.time_zone).hour == 0
			@day = program.days.find_by_date(Date.current - 1)
			@day.update_attributes(result: 3)
		end
	end

	# CLOSE_WINDOW: Close check-in window at 9am local
	Program.active_checkins.all.each do |program|
		user = User.find(program.user_id)
		if Time.now.in_time_zone(user.time_zone).hour == 9
			@day = program.days.find_by_date(Date.current - 2)
			if @day.result == 3
				@day.update_attributes(result: 4)
				# And charge user $1
			end
		end
	end

	# SUPPORTER EMAIL: Send weekly supporter email at 9am the day following the last checkin window (end_date + 2)
	Program.all.each do |program|
		user = User.find(program.user_id)
		if Time.now.in_time_zone(user.time_zone).hour == 9
			if program.start_date? && program.start_date < Date.current && ((Date.current - 1 - program.start_date).to_f/7).prettify.is_a?(Integer)
				program.supporters.each { |supporter| SupporterMailer.supporter_update(supporter).deliver }
			end
		end
	end
end

desc "Tasks to be performed on the half-hour"
task :half_hour_jobs => :environment do
	# REMINDERS_HALF: Send reminders with half hour times
	Program.active_program.all.each do |program|
		user = User.find(program.user_id)
		number_to_send_to = user.phone
		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

		messages = []
		program.remessages.each { |m| messages.push(m.content) }
		message = messages.empty? ? "Future you is thanking present you." : messages.sample

		program.reminders.each do |reminder|
			if Time.zone.now.hour == reminder.time.hour && reminder.time.min == 30
				@twilio_client.account.sms.messages.create(
					:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
					:to => number_to_send_to,
					:body => message
				)
				received_text = program.received_texts.create(message: message)
			end
		end
	end
end

task :test => :environment do
	# TRACKING: Send daily tracking checkin text at 9am local time
	Program.active_checkins.all.each do |program|
		user = User.find(program.user_id)
		if Time.now.in_time_zone(user.time_zone).hour == 13
			number_to_send_to = user.phone
			if program.free_days_left > 0
				std_msg = "[Kick-It] Were you successful yesterday? Reply 'Y' (Yes), 'N' (No), or 'F' (Free Day)."
				custom_msg = "[Kick-It] #{program.days.find_by_date(Date.current).checkin_msg} Reply 'Y' (Yes), 'N' (No), or 'F' (Free Day)."
			else
				std_msg = "[Kick-It] Were you successful yesterday? Reply 'Y' or 'N' to check in."
				custom_msg = "[Kick-It] #{program.days.find_by_date(Date.current).checkin_msg} Reply 'Y' or 'N' to check in."
			end
			message = program.days.find_by_date(Date.current).checkin_msg != nil ? custom_msg : std_msg
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		 
			@twilio_client.account.sms.messages.create(
				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
				:to => number_to_send_to,
				:body => message
			)
			received_text = program.received_texts.create(message: message)
		end
	end
end

task :othertest => :environment do
	# TRACKING: Send daily tracking checkin text at 9am local time
	user = User.find(4)
	program = user.program
	if Time.now.in_time_zone(user.time_zone).hour == 13
		number_to_send_to = user.phone
		if program.free_days_left > 0
			std_msg = "[Kick-It] Were you successful yesterday? Reply 'Y' (Yes), 'N' (No), or 'F' (Free Day)."
			custom_msg = "[Kick-It] #{program.days.find_by_date(Date.current).checkin_msg} Reply 'Y' (Yes), 'N' (No), or 'F' (Free Day)."
		else
			std_msg = "[Kick-It] Were you successful yesterday? Reply 'Y' or 'N' to check in."
			custom_msg = "[Kick-It] #{program.days.find_by_date(Date.current).checkin_msg} Reply 'Y' or 'N' to check in."
		end
		message = program.days.find_by_date(Date.current).checkin_msg != nil ? custom_msg : std_msg
		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
	 
		@twilio_client.account.sms.messages.create(
			:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
			:to => number_to_send_to,
			:body => message
		)
		received_text = program.received_texts.create(message: message)
	end
end