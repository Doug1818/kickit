class Todo < ActiveRecord::Base
  attr_accessible :name, :habit_id
  belongs_to :habits

  validates :name, presence: true
end
