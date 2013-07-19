class AddStripeFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_card_type, :string
    add_column :users, :stripe_card_last4, :string
  end

  def down
  	remove_column :users, :stripe_customer_id
    remove_column :users, :stripe_card_type
    remove_column :users, :stripe_card_last4
  end
end
