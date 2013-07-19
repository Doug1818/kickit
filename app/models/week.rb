class Week < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :free_days, :week
  belongs_to :program
  has_many :days, dependent: :destroy
  scope :current, where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
end
