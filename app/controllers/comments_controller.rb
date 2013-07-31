class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: [:create]

  def create
    @day = Day.find(params[:comment][:day_id])
    @reminder = @day.comments.build(content: params[:comment][:content])
    if @reminder.save
      redirect_to root_path
      flash[:success] = "Comment added"
    else
      render :nothing => true
    end
  end
end
