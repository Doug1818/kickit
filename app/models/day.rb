class Day < ActiveRecord::Base
  attr_accessible :day, :date, :result, :goal, :checkin_msg, :want_count, :did_count
  belongs_to :program
  has_many :comments, dependent: :destroy
  has_many :comments, dependent: :destroy
  scope :reported, joins(:program).where("result IS NOT NULL")
  validates :checkin_msg, length: { maximum: 85 }
end
