class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :email
      t.string :goal
      t.string :habit_name

      t.timestamps
    end
  end
end
