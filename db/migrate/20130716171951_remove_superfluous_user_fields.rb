class RemoveSuperfluousUserFields < ActiveRecord::Migration
  def up
  	remove_column :users, :supporter_name
  	remove_column :users, :supporter_email
  	remove_column :users, :supporter_relationship
  	remove_column :users, :start_date
  	remove_column :users, :end_date
  	remove_column :users, :goal
  	remove_column :users, :checkin_msg
  	remove_column :programs, :setup_flag
  end

  def down
  end
end
