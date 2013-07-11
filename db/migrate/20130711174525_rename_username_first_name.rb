class RenameUsernameFirstName < ActiveRecord::Migration
  def up
  	rename_column :users, :username, :first_name
  end

  def down
  	rename_column :users, :first_name, :username
  end
end
