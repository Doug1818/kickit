class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_user_welcome(user)
    @user = user
    
    mail from:"Kick it <support@kick-it-now.com>",
    to: @user.email,
    subject: "Welcome to Kick it!"
  end
end
