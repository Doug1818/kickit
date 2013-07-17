class AddDailyGoalsFieldsToDays < ActiveRecord::Migration
  def up
  	add_column :days, :goal, :string
  	add_column :days, :checkin_msg, :string
  end

  def down
  	remove_column :days, :goal
  	remove_column :days, :checkin_msg
  end
end
