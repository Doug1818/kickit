class AddSetupCompleteToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :setup_complete, :boolean, :default => false
  end

  def self.down
  	remove_column :users, :setup_complete
  end
end
