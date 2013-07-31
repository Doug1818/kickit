class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.integer :day_id
      t.string :content

      t.timestamps
    end
  end

  def down
  	drop_table :comments
  end
end
