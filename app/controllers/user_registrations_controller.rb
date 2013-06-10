class UserRegistrationsController < Devise::RegistrationsController
skip_before_filter :require_no_authentication, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.start_date = Date.strptime(params[:user][:start_date],"%m/%d/%Y").to_date if params[:user][:start_date] != ""
    if @user.save
      sign_in @user
      redirect_to root_path
      #BarMailer.resrequest(@room, @bar, @user).deliver
      #UserMailer.resrequest_confirmation(@user).deliver
    else
      render 'new'
    end
  end
end