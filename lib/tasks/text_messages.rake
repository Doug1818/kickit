namespace :text do
	#desc "Send text message"
	#task :tracking => :environment do
	#	User.active_checkins.all.each do |user|
	#		number_to_send_to = user.phone
	#		std_msg = "This is your daily Kick it check in. Were you successful yesterday? Reply 'Y' or 'N' to check in."
	#		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
	#	 
	#		@twilio_client.account.sms.messages.create(
	#			:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
	#			:to => number_to_send_to,
	#			:body => user.checkin_msg? ? user.checkin_msg : std_msg
	#		)
	#	end
	#end

	desc "Send reminders with on-the-hour times"
	task :reminders_full => :environment do
		# REMINDERS_FULL: Send reminders with on-the-hour times
		User.active_program.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

			messages = []
			user.remessages.each { |m| messages.push(m.content) }

			user.reminders.each do |reminder|
				if Time.zone.now.hour == reminder.time.hour && reminder.time.min == 0
					@twilio_client.account.sms.messages.create(
						:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
						:to => number_to_send_to,
						:body => messages.empty? ? "Future you is thanking present you." : messages.sample
					)
				end
			end
		end

		# TRACKING: Send daily tracking checkin text at 9am local time
		User.active_checkins.all.each do |user|
			if Time.now.in_time_zone(user.time_zone).hour == 12 # Set back to 9
				number_to_send_to = user.phone
				std_msg = "This is your daily Kick it check in. Were you successful yesterday? Reply 'Y' or 'N' to check in."
				@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
			 
				@twilio_client.account.sms.messages.create(
					:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
					:to => number_to_send_to,
					:body => user.checkin_msg? ? user.checkin_msg : std_msg
				)
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

	desc "Send reminders with half hour times"
	task :reminders_half => :environment do
		# REMINDERS_FULL: Send reminders with half hour times
		User.active_program.all.each do |user|
			number_to_send_to = user.phone
			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

			messages = []
			user.remessages.each { |m| messages.push(m.content) }

			user.reminders.each do |reminder|
				if Time.zone.now.hour == reminder.time.hour && reminder.time.min == 30
					@twilio_client.account.sms.messages.create(
						:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
						:to => number_to_send_to,
						:body => messages.empty? ? "Future you is thanking present you." : messages.sample
					)
				end
			end
		end

		# Test task
		#User.active_checkins.all.each do |user|
		#	if Time.now.in_time_zone(user.time_zone).hour == 11
		#		number_to_send_to = user.phone
		#		std_msg = "This is your daily Kick it check in. Were you successful yesterday? Reply 'Y' or 'N' to check in."
		#		@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
		#	 
		#		@twilio_client.account.sms.messages.create(
		#			:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
		#			:to => "9175879211",
		#			:body => user.checkin_msg? ? user.checkin_msg : std_msg
		#		)
		#	end
		#end
	end
end

#namespace :checkin do
#	desc "Open check-in window"
#	task :open_window => :environment do
#		User.active_checkins.all.each do |user|
#			@day = user.days.find_by_date(Date.current - 1)
#			@day.update_attributes(result: 3)
#		end
#	end
#
#	desc "Close check-in window"
#	task :close_window => :environment do
#		User.active_checkins.all.each do |user|
#			@day = user.days.find_by_date(Date.current - 2)
#			if @day.result == 3
#				@day.update_attributes(result: 4)
#				# And charge user $1
#			end
#		end
#	end
#end
#
#task :time_zone_test => :environment do
#	User.active_checkins.all.each do |user|
#		if Time.now.in_time_zone(user.time_zone).hour == 10
#			number_to_send_to = user.phone
#			std_msg = "This is your daily Kick it check in. Were you successful yesterday? Reply 'Y' or 'N' to check in."
#			@twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
#		 
#			@twilio_client.account.sms.messages.create(
#				:from => "+1#{ENV['TWILIO_PHONE_NUMBER']}",
#				:to => "9175879211",
#				:body => user.checkin_msg? ? user.checkin_msg : std_msg
#			)
#		end
#	end
#end