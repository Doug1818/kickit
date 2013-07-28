class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_user_welcome(user)
    @user = user
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @user.email,
    subject: "Welcome to Kick-It!"
  end

  def start_tomorrow(user)
    @user = user
    @program = @user.program
    @goal = @program.days.first.goal
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @user.email,
    subject: "[Kick-It] Your Program Starts Tomorrow!"
  end

  def supporter_badge(supmessage)
    @supmessage = supmessage
    @supporter = Supporter.find(@supmessage.supporter_id)
    @program = Program.find(@supporter.program_id)
    @user = User.find(@program.user_id)
    
    mail from: @supporter.email,
    to: @user.email,
    subject: "[Kick-It] #{@supporter.first_name} has sent you a badge!"
  end
end
