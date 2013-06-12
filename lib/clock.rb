require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(5.minutes, 'Queueing interval job') { Delayed::Job.enqueue IntervalJob.new }
every(1.day, 'Queueing open window job', :at => '00:00') { Delayed::Job.enqueue OpenWindowJob.new }