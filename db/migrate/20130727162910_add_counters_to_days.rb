class AddCountersToDays < ActiveRecord::Migration
  def up
    add_column :days, :want_count, :integer, default: 0
    add_column :days, :did_count, :integer, default: 0
  end

  def down
  	remove_column :days, :want_count
  	remove_column :days, :did_count
  end
end
