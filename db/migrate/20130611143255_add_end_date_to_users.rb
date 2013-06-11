class AddEndDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :end_date, :date
  end
end
