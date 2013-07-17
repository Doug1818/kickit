class Program < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :habit, :reminders_attributes
  belongs_to :user
  has_many :weeks, dependent: :destroy
  has_many :days, dependent: :destroy
  has_many :sent_texts, dependent: :destroy
  has_many :received_texts, dependent: :destroy
  has_many :supmessages, dependent: :destroy
  has_many :reminders, dependent: :destroy
  accepts_nested_attributes_for :reminders
  has_many :remessages, dependent: :destroy
  has_many :supporters, dependent: :destroy
  has_many :user_todos, dependent: :destroy
  scope :active_program, where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
  scope :active_checkins, where("start_date <= ? AND end_date >= ?", Date.current - 1, Date.current - 1)
  validates :habit, presence: true
  validates :start_date, presence: true, :on => :create
  validate  :future_date, :on => :create
  # validate only one active program
  after_create :build_program
  
  def build_program
  	self.update_attributes(end_date: self.start_date + 20)
    habit = Habit.find_by_name(self.habit)
    habit.cues.each { |cue| self.remessages.create(content: cue.content) } if habit != nil
    habit.todos.each { |todo| self.user_todos.create(name: todo.name) } if habit != nil
    21.times { |i| self.days.create(day: i + 1, date: self.start_date + i) } if start_date != nil
    #create weeks
  end
 
  def future_date
    if self.start_date != nil && self.start_date < Time.zone.now.to_date + 1
      self.errors[:start_date] << "can't be earlier than tomorrow"
    end
  end

  def prev_week
    ((Date.current - 1 - self.start_date)/7).to_i # Current date minus one to account for 1 day checkin lag
  end

  def prev_week_sdays
    x = []
    self.days.reported.order("date desc")[(-7 - 7*(self.prev_week - 1))..(-1 - 7*(self.prev_week - 1))].each { |day| x.push(day.result) if day.result == 1 }
    x.inject(:+)
  end

  def completed_days
    d = Date.current - self.start_date
    d.to_i
  end

  def badge
    if self.prev_week_sdays == 7
      "Congratulations on a perfect week!  Well, in terms of #{self.habit} anyway."
    elsif self.prev_week_sdays <= 6 && self.prev_week_sdays >= 5
      "Strong week.  Strong to Quite Strong."
    elsif self.prev_week_sdays <= 4 && self.prev_week_sdays >= 3
      "Pretty good success rate, but I know you can do better.  I give it about a B."
    elsif self.prev_week_sdays <= 2 && self.completed_days <= 7
      "The first week is always hard.  Make a comeback in week 2!"
    elsif self.prev_week_sdays <= 2 && self.completed_days > 7    
      "Looks like you had a tough week.  Hit the reset button and start fresh next week."
    end
  end
 
  HABITS = ["Smoking", "Drinking", "Caffeine", "Soda", "Sweets / Added Sugars", "Nail Biting", " Facebook / Social Media"]
end
