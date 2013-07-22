class AddDailyCommitmentToProgram < ActiveRecord::Migration
  def up
    add_column :programs, :daily_commitment, :integer, default: 1
  end

  def down
  	remove_column :programs, :daily_commitment
  end
end
