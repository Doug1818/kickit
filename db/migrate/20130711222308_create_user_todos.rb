class CreateUserTodos < ActiveRecord::Migration
  def up
    create_table :user_todos do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end

  def down
  	drop_table :user_todos
  end
end
