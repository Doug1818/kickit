class Supporter < ActiveRecord::Base
  attr_accessible :email, :first_name, :relationship
  belongs_to :user
end
