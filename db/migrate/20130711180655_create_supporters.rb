class CreateSupporters < ActiveRecord::Migration
  def up
    create_table :supporters do |t|
      t.string :first_name
      t.string :email
      t.integer :user_id
      t.string :relationship

      t.timestamps
    end
  end

  def down
  	drop_table :supporters
  end
end
