class SupporterMailer < ActionMailer::Base
  default from: "from@example.com"

  def supporter_welcome(supporter)
    @supporter = supporter
    @user = User.find(supporter.user_id)
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @supporter.email,
    subject: "#{@user.email} named you as a supporter on Kick-It!"
  end

  def supporter_update(supporter)
    @supporter = supporter
    @user = User.find(supporter.user_id)

    mail from:"KickIt <support@kick-it-now.com>",
    to: @supporter.email,
    bcc: "support@kick-it-now.com",
    subject: "[Kick-It] Weekly Update on #{@user.email}"
  end
end
