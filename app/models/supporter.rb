class Supporter < ActiveRecord::Base
  attr_accessible :email, :first_name, :relationship
  has_many :supmessages, dependent: :destroy
  belongs_to :user
  belongs_to :program

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX }
  validates :first_name, presence: true
  validates :relationship, presence: true

  RELATIONSHIPS = ["Friend", "Boyfriend", "Girlfriend", "Husband", "Wife", "Father", "Mother", "Son", "Daughter",
    "Brother", "Sister", "Uncle", "Aunt", "Nephew", "Niece", "Cousin", "Other"]
end
