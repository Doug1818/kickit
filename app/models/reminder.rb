class Reminder < ActiveRecord::Base
  attr_accessible :name, :time
  belongs_to :user
end
