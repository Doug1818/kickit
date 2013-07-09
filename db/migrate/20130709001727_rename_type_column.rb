class RenameTypeColumn < ActiveRecord::Migration
  def up
  	rename_column :habits, :type, :name
  end

  def down
  end
end
