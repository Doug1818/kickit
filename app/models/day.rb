class Day < ActiveRecord::Base
  attr_accessible :day, :date, :result, :goal, :checkin_msg
  belongs_to :user
  belongs_to :program
  belongs_to :week
  scope :reported, joins(:user).where("result IS NOT NULL")
end
