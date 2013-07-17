class Week < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :free_days, :week
  belongs_to :program
  has_many :days, dependent: :destroy
end
