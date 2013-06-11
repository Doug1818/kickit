class CreateSentTexts < ActiveRecord::Migration
  def change
    create_table :sent_texts do |t|
      t.integer :user_id
      t.string :message

      t.timestamps
    end
  end
end
