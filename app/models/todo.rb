class Todo < ActiveRecord::Base
  attr_accessible :name
  belongs_to :habits

  validates :name, presence: true
end
