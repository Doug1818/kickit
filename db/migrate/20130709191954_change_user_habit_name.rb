class ChangeUserHabitName < ActiveRecord::Migration
  def up
  	rename_column :users, :habit, :habit_name
  end

  def down
  	rename_column :users, :habit_name, :habit
  end
end
