class AddAbValueToLeads < ActiveRecord::Migration
  def self.up
    add_column :leads, :ab_value, :string
  end

  def self.down
  	remove_column :leads, :ab_value
  end
end
