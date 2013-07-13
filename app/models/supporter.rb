class Supporter < ActiveRecord::Base
  attr_accessible :email, :first_name, :relationship
  belongs_to :user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX }
  validates :first_name, presence: true
  validates :relationship, presence: true
end
