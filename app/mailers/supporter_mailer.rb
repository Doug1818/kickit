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
    @token = generate_token(@supporter)
    @program = Program.find(supporter.program_id)
    @user = User.find(@program.user_id)
    @new_week = @program.weeks.closed[0]
    #@new_week = @program.weeks.find_by_week(1)

    mail from:"Kick-It <support@kick-it-now.com>",
    to: @supporter.email,
    bcc: "support@kick-it-now.com",
    subject: "[Kick-It] Weekly Update on #{@user.email}"
  end

  def generate_token(supporter)
    Base64.encode64("#{supporter.id}X#{supporter.first_name}#{supporter.relationship}").gsub(/[^0-9a-z]/i, "")
  end

  def supporter_survey(supporter)
    @supporter = supporter
    @program = Program.find(@supporter.program_id)
    @user = User.find(@program.user_id)

    mail from:"Kick-It <support@kick-it-now.com>",
    to: @supporter.email,
    bcc: "support@kick-it-now.com",
    subject: "[Kick-It] Thanks for Being Supporter!"
  end
end
