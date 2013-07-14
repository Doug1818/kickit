class AddCompletedToUserTodos < ActiveRecord::Migration
  def change
    add_column :user_todos, :completed, :boolean, :default => false
  end
end
