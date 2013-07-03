class CreateSupmessages < ActiveRecord::Migration
  def self.up
    create_table :supmessages do |t|
      t.integer :user_id
      t.string :content

      t.timestamps
    end
  end

  def self.down
  	drop_table :supmessages
  end
end
