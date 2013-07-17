class RenameUsersHabitNameFirstHabit < ActiveRecord::Migration
  def up
  	rename_column :users, :habit_name, :first_habit
  end

  def down
  end
end
