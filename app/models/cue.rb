class Cue < ActiveRecord::Base
  attr_accessible :content
  belongs_to :habits

  validates :content, presence: true, length: { maximum: 150 }
end
