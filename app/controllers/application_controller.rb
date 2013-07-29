class ApplicationController < ActionController::Base
	helper :all
	protect_from_forgery
	before_filter :prepare_for_mobile
	around_filter :user_time_zone, if: :current_user

	#def after_sign_in_path_for(resource)
  #  if current_user.current_program != nil # If in an active program
  #    calendar_path
  #  elsif current_user.program == nil # If signed up only
  #  	signedup_path
  #	elsif current_user.programs.count >= 1 && current_user.next_program.start_date > Date.current # If signed up / setup but not started
  #		checklist_path
  #	end
  #end

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

	# Exception handling (custom error messages)
	unless Rails.application.config.consider_all_requests_local
		rescue_from Exception, with: lambda { |exception| render_error 500, exception }
		rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
	end

	private
	def render_error(status, exception)
		respond_to do |format|
			format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
			format.all { render nothing: true, status: status }
		end
	end
end
