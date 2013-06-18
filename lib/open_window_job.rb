class OpenWindowJob
	def perform
		Day.create(result: "999")
	end
end