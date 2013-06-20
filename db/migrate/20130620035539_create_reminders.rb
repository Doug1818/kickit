class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :user_id
      t.datetime :time
      t.string :name

      t.timestamps
    end
  end
end
