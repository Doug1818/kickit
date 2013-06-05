class AddDayToDays < ActiveRecord::Migration
  def change
    add_column :days, :day, :integer
  end
end
