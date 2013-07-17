class RenameWeeksUserIdProgramId < ActiveRecord::Migration
  def up
  	rename_column :weeks, :user_id, :program_id
  end

  def down
  end
end
