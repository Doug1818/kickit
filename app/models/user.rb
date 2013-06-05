class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :name, :phone, :habit, :start_date, :supporter_name, :supporter_email
  has_many :days, dependent: :destroy

  after_create :create_30_days

  def create_30_days
  	30.times { |i| self.days.create(day: i + 1) }
  end
end
