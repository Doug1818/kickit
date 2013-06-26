class ApplicationController < ActionController::Base
	helper :all
	protect_from_forgery
	before_filter :prepare_for_mobile
	around_filter :user_time_zone, if: :current_user

	private

	# For mobile
	def mobile_device?
		if session[:mobile_param]
			session[:mobile_param] == "1"
		else
			request.user_agent =~ /Mobile|webOS/
		end
	end
	helper_method :mobile_device?

	def prepare_for_mobile
		session[:mobile_param] = params[:mobile] if params[:mobile]
    	request.format = :mobile if mobile_device?
	end

	# For time zones
	def user_time_zone(&block)
		Time.use_zone(current_user.time_zone, &block)
	end
end
