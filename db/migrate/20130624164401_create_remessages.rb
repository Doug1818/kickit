class CreateRemessages < ActiveRecord::Migration
  def change
    create_table :remessages do |t|
      t.integer :user_id
      t.string :content

      t.timestamps
    end
  end
end
