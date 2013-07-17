class CreatePrograms < ActiveRecord::Migration
  def up
    create_table :programs do |t|
      t.integer :user_id
      t.string :habit
      t.date :start_date
      t.date :end_date
      t.boolean :setup_flag

      t.timestamps
    end
  end

  def down
    drop_table :programs
  end
end
