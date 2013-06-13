require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

module IntervalModule

class IntervalJob < Struct.new(:number_to_send_to, :twilio_client, :number_sent_from)
	def perform
		@twilio_client.account.sms.messages.create(
			:from => number_sent_from,
			:to => number_to_send_to,
			:body => "Reminder test"
		)
	end
end

end