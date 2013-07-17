class UserTodo < ActiveRecord::Base
  attr_accessible :name, :completed
  belongs_to :user
  belongs_to :program

  validates :name, presence: true
end
