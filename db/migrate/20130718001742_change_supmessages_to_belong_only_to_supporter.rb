class ChangeSupmessagesToBelongOnlyToSupporter < ActiveRecord::Migration
  def up
  	add_column :supmessages, :supporter_id, :integer
  	remove_column :supmessages, :user_id
  	remove_column :supmessages, :program_id
  end

  def down
  end
end
