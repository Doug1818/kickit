class SentText < ActiveRecord::Base
  attr_accessible :message
  belongs_to :user
end
