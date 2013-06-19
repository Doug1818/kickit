class RegistrationsController < Devise::RegistrationsController
skip_before_filter :require_no_authentication, :only => [:new, :create]

  def new
    @user = User.new
    if user_signed_in?
      @days = current_user.days
      @today = params[:month] ? Date.parse(params[:month]) : Date.today
    end
  end

  def create
    @user = User.new(params[:user])
    if params[:user][:start_date] != "" && !@user.start_date.is_a?(Date)
      @user.start_date = Date.strptime(params[:user][:start_date],"%m/%d/%Y").to_date
    end
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