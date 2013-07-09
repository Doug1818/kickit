class Habit < ActiveRecord::Base
  attr_accessible :name
  has_many :cues
  has_many :todos

  validates :name, presence: true

  # For rails admin
  def custom_label_method
    "#{self.name}"
  end
end
