class UserTodo < ActiveRecord::Base
  attr_accessible :name, :completed
  belongs_to :user

  validates :name, presence: true
end
