class RenameSetupCompleteColumn < ActiveRecord::Migration
  def up
  	rename_column :users, :setup_complete, :setup_flag
  end

  def down
  	rename_column :users, :setup_flag, :setup_complete
  end
end
