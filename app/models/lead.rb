class Lead < ActiveRecord::Base
  attr_accessible :email, :first_name, :goal, :habit_name, :ab_value

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :goal, presence: true
  validates :habit_name, presence: true
end
