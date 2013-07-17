class AddWeekIdToDays < ActiveRecord::Migration
  def up
    add_column :days, :week_id, :integer
  end

  def down
  	remove_column :days, :week_id
  end
end
