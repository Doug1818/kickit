class ErrorsController < ApplicationController
	layout :web_layout, only: [:error_404, :error_500]
  
	def error_404
		@not_found_path = params[:not_found]
	end

	def error_500
	end

	private
    def web_layout
      if params[:format] != "mobile"
        "user_web"
      else
        "application"
      end
    end
end
