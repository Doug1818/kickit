class CreateReceivedTexts < ActiveRecord::Migration
  def self.up
    create_table :received_texts do |t|
      t.integer :user_id
      t.string :message

      t.timestamps
    end
  end

  def self.down
  	drop_table :received_texts
  end
end
