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
    @goal = @program.days.find_by_day(1).goal
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @user.email,
    subject: "[Kick-It] Your Program Starts Tomorrow!"
  end

  def checkin_msg_correction(user)
    @user = user
    @program = @user.program
    @msg_received = @program.days.find_by_day(8).checkin_msg
    @msg_corrected = @program.days.find_by_day(1).checkin_msg
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @user.email,
    bcc: "support@kick-it-now.com",
    subject: "[Kick-It] Check-in Message Correction"
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

  def week_in_review(user)
    @user = user
    @program = @user.program
    @new_week = @program.weeks.closed[0]
    subject = @new_week.missed > 0 ? "[Kick-It] We charged you $#{@new_week.missed}" : "[Kick-It] We emailed your supporter"

    mail from:"Kick-It <support@kick-it-now.com>",
    to: @user.email,
    bcc: "support@kick-it-now.com",
    subject: subject
  end
end
