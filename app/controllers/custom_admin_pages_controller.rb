class CustomAdminPagesController < ApplicationController
  before_filter :authenticate_admin!
  layout :web_layout

  def update_programs
    @programs = Program.active_program.all
  end

  private
    def web_layout
      if params[:format] != "mobile"
        "user_web"
      else
        "application"
      end
    end
end