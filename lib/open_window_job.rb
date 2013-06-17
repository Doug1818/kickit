require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

module OpenWindowModule

class OpenWindowJob
	def perform
		Day.create(result: "999")
	end
end

end