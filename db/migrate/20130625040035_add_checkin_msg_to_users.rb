class AddCheckinMsgToUsers < ActiveRecord::Migration
  def change
    add_column :users, :checkin_msg, :string
  end
end
