require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

#every(1.minute, 'Queueing interval job') { Delayed::Job.enqueue IntervalJob.new }
#every(10.minutes, 'Queueing open window job') { Delayed::Job.enqueue OpenWindowJob.new }