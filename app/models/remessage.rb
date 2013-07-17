class Remessage < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  belongs_to :program

  validates :content, presence: true
end
