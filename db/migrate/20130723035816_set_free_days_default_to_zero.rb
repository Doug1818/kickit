class SetFreeDaysDefaultToZero < ActiveRecord::Migration
  def up
  	change_column :weeks, :free_days, :integer, default: 0
  end

  def down
  	change_column :weeks, :free_days, :integer, default: nil
  end
end
