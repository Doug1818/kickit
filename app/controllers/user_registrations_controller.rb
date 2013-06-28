class UserRegistrationsController < Devise::RegistrationsController
skip_before_filter :require_no_authentication, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome! You have signed up successfully."
      redirect_to root_path
      UserMailer.new_user_welcome(@user).deliver
    else
      render 'new'
    end
  end
end