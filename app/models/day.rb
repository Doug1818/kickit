class Day < ActiveRecord::Base
  attr_accessible :day, :date, :result
  belongs_to :user
end
