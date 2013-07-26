class Csmessage < ActiveRecord::Base
  attr_accessible :message
  belongs_to :program
end
