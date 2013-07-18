class Supmessage < ActiveRecord::Base
  attr_accessible :content
  belongs_to :supporter

  validates :content, presence: true
end
