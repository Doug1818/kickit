class RegistrationsController < Devise::RegistrationsController
skip_before_filter :require_no_authentication, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if params[:user][:start_date] != "" && !@user.start_date.is_a?(Date)
      @user.start_date = Date.strptime(params[:user][:start_date],"%m/%d/%Y").to_date
    end
    if @user.save
      sign_in @user
      redirect_to root_path
      #UserMailer.resrequest_confirmation(@user).deliver
    else
      render 'new'
    end
  end
end