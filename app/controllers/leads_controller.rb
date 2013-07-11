class LeadsController < ApplicationController

  def create
    @lead = Lead.new(params[:lead])
    #binding.pry
    if @lead.save
      flash[:success] = "You have signed up successfully. Thank you for your interest in Kick-It!"
      redirect_to root_path
      begin
        gb = Gibbon.new(ENV['MAILCHIMP_API_KEY'])
        list_id = gb.lists({:list_name => "Leads"})["data"].first["id"]
        gb.list_subscribe(:id => list_id, :email_address => @lead.email, :merge_vars => {'FNAME' => @lead.first_name, 'GOAL' => @lead.goal, 'HABIT' => @lead.habit_name, 'AB_VALUE' => @lead.ab_value }, :double_optin => false)
      rescue Gibbon::MailChimpError => e
        return
      end
      #UserMailer.new_user_welcome(@user).deliver
    else
      if params[:lead][:ab_value] == "A"
        render 'static_pages/landing_a.html'
      else
        render 'static_pages/landing_b.html'
      end
    end
  end
end
