class CreateCues < ActiveRecord::Migration
  def change
    create_table :cues do |t|
      t.string :content
      t.integer :habit_id

      t.timestamps
    end
  end
end
