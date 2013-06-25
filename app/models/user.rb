class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  attr_accessible :username, :name, :phone, :habit, :start_date, :end_date, :supporter_name, :supporter_email, :supporter_relationship, 
    :goal, :checkin_msg, :reminders_attributes
  has_many :days, dependent: :destroy
  has_many :sent_texts, dependent: :destroy
  has_many :reminders, dependent: :destroy
  accepts_nested_attributes_for :reminders
  has_many :remessages, dependent: :destroy
  scope :active_program, where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
  scope :active_checkins, where("start_date <= ? AND end_date >= ?", Date.current - 1, Date.current - 1)
  #after_create :create_30_days

  #def create_30_days
  #	30.times { |i| self.days.create(day: i + 1, date: self.start_date + i) } if self.start_date?
  #  self.update_attributes(end_date: start_date + 30)
  #end

  RELATIONSHIPS = ["Friend", "Boyfriend", "Girlfriend", "Husband", "Wife", "Father", "Mother", "Son", "Daughter",
    "Brother", "Sister", "Uncle", "Aunt", "Nephew", "Niece", "Cousin", "Other", "Don't share my progress"]
  HABITS = ["Smoking", "Drinking", "Dipping", "Alcohol", "Coffee", "Soda", "Sweets", "Processed sugars", "Nail biting", 
    "Nuckle cracking", "Playing with hair", "Losing temper", "Watching crap TV", "Playing video games", 
    "Surfing Facebook / the internet"]
  
  REMESSAGES = ["Soda", "Surfing Facebook / the internet"]
  
  SODA = ["Have a seltzer today",
          "Sub in one black or green tea today",
          "As long as you're improving, it doesn't matter how fast you're improving.",
          "Future you is thanking present you."]
  SURFING = ["If Facebook is open right now, close it.",
          "Today, do a 2-hour block with Self Control or Cold Turkey.",
          "As long as you're improving, it doesn't matter how fast you're improving.",
          "Here's a link to a study about how Facebook is good for you: http://www.psmag.com/blogs/news-blog/why-you-cant-stop-checking-your-facebook-profile-52531/"]

  after_create :add_remessages
  def add_remessages
    soda = "Soda"
    surfing = "Surfing Facebook / the internet"
    if REMESSAGES.include?(self.habit)
      if soda == self.habit
        SODA.each { |message| self.remessages.create(content: message) }
      elsif surfing == self.habit
        SURFING.each { |message| self.remessages.create(content: message) }
      end
    end
  end
end
