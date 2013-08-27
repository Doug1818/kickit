class AdminMailer < ActionMailer::Base
  default from: "from@example.com"

  def update_goals_reminder(program)
    @program = program
    @user = User.find(@program.user_id)
    @admins = ["Rick McMullen <rmcmullen@mba2014.hbs.edu>", 
    		   "Doug Raicek <draicek@mba2014.hbs.edu>"]
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @admins,
    cc: "Kick-It <support@kick-it-now.com>",
    subject: "[Kick-It Admin] Time to update some goals"
  end

  def csmessage_alert(csmessage)
  	@csmessage = csmessage
  	@program = Program.find(@csmessage.program_id)
  	@user = User.find(@program.user_id)
    @admins = ["Rick McMullen <rmcmullen@mba2014.hbs.edu>", 
    		   "Doug Raicek <draicek@mba2014.hbs.edu>"]
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @admins,
    cc: "Kick-It <support@kick-it-now.com>",
    subject: "[Kick-It Admin] Customer Service text from #{@user.email}"
  end

  def triple_x_alert(program)
  	@program = program
    @user = User.find(@program.user_id)
    @admins = ["Rick McMullen <rmcmullen@mba2014.hbs.edu>", 
    		   "Doug Raicek <draicek@mba2014.hbs.edu>"]
    
    mail from:"Kick-It <support@kick-it-now.com>",
    to: @admins,
    cc: "Kick-It <support@kick-it-now.com>",
    subject: "[Kick-It Admin] #{@user.email} is struggling with their goal"
  end
end
