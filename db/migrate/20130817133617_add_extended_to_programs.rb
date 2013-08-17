class AddExtendedToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :extended, :boolean, default: false
  end
end
