class UserTodosController < ApplicationController
  before_filter :authenticate_user!, only: [:complete]

  def complete
    @user_todo = UserTodo.find(params[:id])
    if @user_todo.completed == false
      @user_todo.update_attributes!(completed: true)
    else
      @user_todo.update_attributes!(completed: false)
    end
    redirect_to root_path
  end
end
