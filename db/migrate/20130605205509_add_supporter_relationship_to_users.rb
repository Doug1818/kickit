class AddSupporterRelationshipToUsers < ActiveRecord::Migration
  def change
    add_column :users, :supporter_relationship, :string
  end
end
