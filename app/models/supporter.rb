class Supporter < ActiveRecord::Base
  attr_accessible :email, :first_name, :relationship, :user_id
end
