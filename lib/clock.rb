require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'
require Rails.root.join("lib/interval_job.rb")
require Rails.root.join("lib/open_window_job.rb")

include Clockwork
include IntervalModule
include OpenWindowModule

every(5.minutes, 'Queueing interval job') { Delayed::Job.enqueue IntervalModule::IntervalJob.new("9175879211", Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']), "+1#{ENV['TWILIO_PHONE_NUMBER']}") }
every(2.minutes, 'Queueing open window job') { Delayed::Job.enqueue OpenWindowModule::OpenWindowJob.new }