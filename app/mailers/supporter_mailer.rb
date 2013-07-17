class SupporterMailer < ActionMailer::Base
  default from: "from@example.com"

  def supporter_welcome(supporter)
    @supporter = supporter
    @program = Program.find(supporter.program_id)
    @user = User.find(@program.user_id)
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @supporter.email,
    subject: "#{@user.email} named you as a supporter on Kick-It!"
  end

  def supporter_update(supporter)
    @supporter = supporter
    @program = Program.find(supporter.program_id)
    @user = User.find(@program.user_id)

    mail from:"Kick-It <support@kick-it-now.com>",
    to: @supporter.email,
    bcc: "support@kick-it-now.com",
    subject: "[Kick-It] Weekly Update on #{@user.email}"
  end
end
