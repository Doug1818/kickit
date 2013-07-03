class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_user_welcome(user)
    @user = user
    
    mail from:"KickIt <support@kick-it-now.com>",
    to: @user.email,
    subject: "Welcome to KickIt!"
  end

  def supporter_welcome(user)
    @user = user
    
    mail from:"KickIt <support@kick-it-now.com>",
    to: @user.supporter_email,
    subject: "#{@user.email} has named you as a supporter on KickIt!"
  end

  def supporter_badge(supmessage)
    @supmessage = supmessage
    @user = User.find(@supmessage.user_id)
    
    mail from:"#{@user.supporter_name} <#{@user.supporter_email}>",
    to: @user.email,
    subject: "[KickIt] #{@user.supporter_name} has sent you a badge!"
  end

  def supporter_update(user)
    @user = user

    mail from:"KickIt <support@kick-it-now.com>",
    to: @user.supporter_email,
    bcc: "support@kick-it-now.com",
    subject: "[KickIt] Weekly Update on #{@user.email}"
  end
end
