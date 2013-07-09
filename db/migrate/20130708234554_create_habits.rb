class CreateHabits < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.string :type

      t.timestamps
    end
  end
end
