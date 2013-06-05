class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :habit, :string
    add_column :users, :start_date, :date
    add_column :users, :supporter_name, :string
    add_column :users, :supporter_email, :string
  end
end
