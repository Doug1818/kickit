class Program < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :habit, :daily_commitment, :reminders_attributes, :extended,
    :user_id
  belongs_to :user
  has_many :weeks, dependent: :destroy
  has_many :days, dependent: :destroy
  has_many :sent_texts, dependent: :destroy
  has_many :received_texts, dependent: :destroy
  has_many :reminders, dependent: :destroy
  accepts_nested_attributes_for :reminders
  has_many :remessages, dependent: :destroy
  has_many :csmessages, dependent: :destroy
  has_many :supporters, dependent: :destroy
  has_many :user_todos, dependent: :destroy
  scope :active_program, where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
  scope :active_checkins, where("start_date <= ? AND end_date >= ?", Date.current - 1, Date.current - 1)
  scope :close_window, where("start_date <= ? AND end_date >= ?", Date.current - 2, Date.current - 2)
  scope :start_tomorrow, where("start_date = ?", Date.current + 1)
  scope :end_tomorrow, where("end_date = ?", Date.current + 1)
  scope :start29, where("start_date = ?", Date.new(2013, 7, 29))
  scope :start_today, where("start_date = ?", Date.current)
  scope :nb, where("habit = ?", "Biting Nails")
  scope :lns, where("habit = ?", "Late Night Snacking")
  scope :oe, where("habit = ?", "Overeating at Meals")
  scope :es, where("habit = ?", "Eating Sweets")
  scope :soda, where("habit = ?", "Drinking Soda")
  validates :habit, presence: true
  validates :start_date, presence: true, :on => :create
  validate  :future_date, :on => :create
  # validate only one active program
  after_create :build_program
  
  # For rails admin
  def custom_label_method
    "#{User.find(self.user_id).email}" if self.user_id?
  end

  def build_program
  	days_num = 21
    weeks_num = days_num/7
    self.update_attributes(end_date: self.start_date + 20)
    habit = Habit.find_by_name(self.habit)
    habit.cues.each { |cue| self.remessages.create(content: cue.content) } if habit != nil
    habit.todos.each { |todo| self.user_todos.create(name: todo.name) } if habit != nil
    self.user_todos.create(name: "Hit the<img src=\"/assets/share-button.png\" class=\"checklist_image\" /> button then 'Add to Home Screen' to create a bookmark icon on your iPhone")
    days_num.times { |i| self.days.create(day: i + 1, date: self.start_date + i) } if start_date != nil
    weeks_num.times { |i| self.weeks.create(week: i + 1, start_date: self.start_date + i*7, end_date: self.start_date + 6 + i*7 ) }
  end
 
  def this_week
    self.weeks.find { |w| w.start_date <= Date.current && w.end_date >= Date.current }
  end

  def last_week
    self.weeks.find { |w| w.week == self.this_week.week - 1 }
  end

  def next_week
    if self.this_week == nil
      nil
    else
      self.weeks.find { |w| w.week == self.this_week.week + 1 }
    end
  end

  def free_days_left
    if self.this_week == nil
      nil
    else
      self.this_week.free_days - self.this_week.used_free_days
    end
  end

  def this_week_checkin
    self.weeks.find { |w| w.start_date <= Date.current - 1 && w.end_date >= Date.current - 1 }
  end

  def free_days_left_checkin
    self.this_week_checkin.free_days - self.this_week_checkin.used_free_days
  end

  def missed
    x = [0]
    self.days.each { |day| x.push(1) if day.result == 4 }
    x.inject(:+)
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
    self.days.reported.order("date desc")[(-7 - 7*(self.prev_week - 1))..(-1 - 7*(self.prev_week - 1))].each { |day| x.push(1) if day.result == 1 }
    x.inject(:+)
  end

  def completed_days
    d = Date.current - self.start_date
    d.to_i
  end

  def habit_for_sentence
    if self.habit == "Biting Nails"
      "bite your nails"
    elsif self.habit == "Checking Facebook"
      "check Facebook"
    elsif self.habit == "Late Night Snacking"
      "have a late night snack"
    elsif self.habit == "Overeating at Meals"
      "overeat"
    elsif self.habit == "Eating Sweets"
      "eat sweets"
    elsif self.habit == "Drinking Soda"
      "drink soda"
    end
  end
 
  HABITS = ["Biting Nails", "Checking Facebook", "Late Night Snacking", "Overeating at Meals", "Eating Sweets", "Drinking Soda", "Other"]
end
