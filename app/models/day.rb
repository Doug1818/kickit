class Day < ActiveRecord::Base
  attr_accessible :day, :date, :result
  belongs_to :user
  scope :reported, joins(:user).where("result IS NOT NULL")
end
