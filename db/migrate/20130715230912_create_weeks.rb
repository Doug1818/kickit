class CreateWeeks < ActiveRecord::Migration
  def up
    create_table :weeks do |t|
      t.integer :week
      t.date :start_date
      t.date :end_date
      t.integer :free_days
      t.integer :user_id

      t.timestamps
    end
  end

  def down
    drop_table :weeks
  end
end
