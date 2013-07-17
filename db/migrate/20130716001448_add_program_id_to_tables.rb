class AddProgramIdToTables < ActiveRecord::Migration
  def up
  	add_column :days, :program_id, :integer
  	add_column :received_texts, :program_id, :integer
  	add_column :sent_texts, :program_id, :integer
  	add_column :supporters, :program_id, :integer
  	add_column :supmessages, :program_id, :integer
  	add_column :remessages, :program_id, :integer
  	add_column :reminders, :program_id, :integer
  	add_column :user_todos, :program_id, :integer
  	add_column :weeks, :user_id, :integer
  end
end
