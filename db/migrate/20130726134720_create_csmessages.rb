class CreateCsmessages < ActiveRecord::Migration
  def up
    create_table :csmessages do |t|
      t.integer :program_id
      t.string :message

      t.timestamps
    end
  end

  def down
  	drop_table :csmessages
  end
end
